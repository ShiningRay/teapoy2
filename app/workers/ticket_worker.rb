#!/usr/bin/env ruby
# coding: utf-8

class TicketWorker  < BaseWorker
  def check(topic_id)
    puts '===new==='
    topic = Topic.find topic_id
    return unless topic.status == 'pending'

    unless @ticket_types
      @ticket_types = {}
      TicketType.all.each do |tt|
        @ticket_types[tt.id] = tt
      end
    end
    @tickets = topic.tickets.find :all, :conditions => 'ticket_type_id is not null'

    return if @tickets.size < 5
    scores = @tickets.collect do |t|
      tp = @ticket_types[t.ticket_type_id]
      w = t.user.ensure_weight
      we = (tp.weight > 0 ? w.pos_weight : w.neg_weight)
      tp.weight * we
    end
    scores.reject!{|i|i==0.0}
    score = scores.sum
    num = scores.size
    av = score / num
    ub = 3.0 / num - 0.05
#lb = -3.33 / num + 0.066
    lb=-8.5/num+0.3
    puts "check,#{topic.id},#{@tickets.size},#{num},#{score},#{av}"
    if num < 16
      if av <= lb
        puts "reject #{topic_id} due to avg #{av}"
        judge(:topic_id => topic_id, :approval => false)
      elsif av >= ub
        puts "accept #{topic_id} due to avg #{av}"
        judge(:topic_id => topic_id, :approval => true)
      end
    else
      if av >= 0.02
        puts 'accept'
        judge(:topic_id => topic_id, :approval => true)
      else
        puts 'reject'
        judge(:topic_id => topic_id, :approval => false)
      end
    end
    puts '========='
  rescue => e
    puts e
    puts e.backtrace.join("\n")
  end

  def judge(options)
    topic_id = options[:topic_id]
    approval = options[:approval]

    puts "judging #{topic_id}"
    topic = Topic.find topic_id

    if approval
      topic.publish!
    else
      topic.reject!
    end

    topic.tickets.each do |t|
      next unless t.ticket_type
      a = (t.ticket_type.weight > 0)
      t.correct = (a == approval)
      t.save!
    end
  rescue => e
    puts e
    puts e.backtrace.join("\n")
  end

end

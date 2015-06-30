#!/usr/bin/env ruby
# coding: utf-8
class ScoreWorker  < BaseWorker
  def vote(options)
    action = options[:action]
    id = options[:id]
    puts "#{action}, #{id}"
    case action
    when :up
      query = "UPDATE scores SET pos=pos+1 WHERE article_id=#{id}"
    when :down
      query = "UPDATE scores SET neg=neg-1 WHERE article_id=#{id}"
    end
    Score.connection.execute query

    #ScoreWorker.async_update id
    update id
  rescue => e
    puts e
    puts e.backtrace.join("\n")
  end

  def update(id)
    article = Topic.find id
    gid = article.group_id
    @ids ||= {}
    @ids[gid] ||= Set.new
    @ids[gid] << id
    #@timer ||= EM.add_timer 5*60, method(:bulkupdate)
    #puts @ids.inspect
    bulkupdate if @ids[gid].size >= 43
  rescue => e
    puts e
    puts e.backtrace.join("\n")
  end

  def bulkupdate
    @ids.each do |gid, s|
      next if s.size == 0
      al = Group.find(gid).inherited_option(:score_algorithm)
      sql = "update scores set score=(#{al}) where article_id in (#{s.to_a.join(',')})"
      puts "---#{gid}---"
      puts sql
      Score.connection.execute sql
      s.clear
    end
    #@timer = nil
  rescue => e
    puts e
    puts e.backtrace.join("\n")
  end
end

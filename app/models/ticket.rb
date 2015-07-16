# coding: utf-8
# == Schema Information
#
# Table name: tickets
#
#  id             :integer          not null, primary key
#  user_id        :integer          not null
#  topic_id       :integer          not null
#  ticket_type_id :integer
#  correct        :boolean
#  created_at     :datetime
#  updated_at     :datetime
#  viewed_at      :datetime
#
# Indexes
#
#  article_id                             (topic_id)
#  full_idx                               (user_id,topic_id,ticket_type_id,correct)
#  index_tickets_on_user_id_and_topic_id  (user_id,topic_id) UNIQUE
#

class Ticket < ActiveRecord::Base
  belongs_to :user
  belongs_to :ticket_type
  belongs_to :topic
  after_create :update_counter
  after_save :update_correct
  def self.topic_score(topic_id)
    topic = Topic.find topic_id
    @tickets = topic.tickets.find :all
    return 0.0 unless @tickets
    score = 0.0
    @tickets.each do |t|
      next if not t.ticket_type_id
      tp = t.ticket_type
      w = t.user.ensure_weight
      score += tp.weight * (tp.weight > 0 ? w.pos_weight : w.neg_weight)
    end
    score
  end
  def self.stats
    t = Time.parse ENV['DATE']
    topics = Topic.where('created_at >= ? and created_at < ?', t, t+24.hours)
    topics.each do |a|
      puts "#{a.id}, #{topic_score(a.id)}"
    end
  end
  def self.dump
    Ticket.paginated_each(:conditions => "created_at >='2010-6-1'") do |a|
      puts "#{a.id}, #{a.user_id}, #{a.correct}, #{a.ticket_type_id}, #{a.ticket_type ? a.ticket_type.weight : ''}, #{a.created_at}, #{a.user.ensure_weight.ratio}," + \
        "#{a.ticket_type ? (a.ticket_type.weight > 0 ? a.user.ensure_weight.pos_weight : a.user.ensure_weight.neg_weight ) : '' }"
    end
  end
  protected
  def update_counter
    if ticket_type
      w = user.ensure_weight
      transaction do
        w.lock!
        w.update_all
#        if ticket_type.weight > 0
#          w.increment :pos
#        else
#          w.increment :neg
#        end
        w.save!
      end
    end
  end
  def update_correct
    if correct_changed?
      w = user.ensure_weight
      transaction do
        w.lock!
        w.update_all
#        if correct
#          w.increment :correct
#          if ticket_type.weight > 0
#            w.increment :pos_correct
#          else
#            w.increment :neg_correct
#          end
#        else
#          w.decrement :correct
#          if ticket_type.weight > 0
#            w.decrement :pos_correct
#          else
#            w.decrement :neg_correct
#          end
#        end
        w.save!
      end
    end
  end
end

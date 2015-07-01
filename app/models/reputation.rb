# coding: utf-8
# == Schema Information
#
# Table name: reputations
#
#  id       :integer          not null, primary key
#  user_id  :integer
#  group_id :integer
#  value    :integer          default(0)
#  state    :string(255)      default("neutral")
#  hide     :boolean          default(FALSE)
#

class Reputation < ActiveRecord::Base
  class_attribute :levels, :level_order
  include Tenacity
  belongs_to :user
  t_belongs_to :group
  has_many :logs, :class_name => 'ReputationLog'

  scope :by_group, ->(group){where(group_id: group.id)}
  include Comparable

  def <=>(other)
    case other
    when Integer
      value <=> other
    when Reputation
      value <=> other.value
    when String, Symbol
      level_order.index(level) <=> level_order.index(other.to_sym)
    end
  end

  def ==(other)
    case other
    when Integer
      value == other
    when Reputation
      value == other.value
    when String, Symbol
      level == other.to_sym
    end
  end

  def +(other)
    value + other.to_i
  end

  self.levels = {
    :unfriendly => -1_000,
    :neutral => 0,
    :friendly => 100,
    :honored => 500,
    :revered => 1_000,
    :exalted => 3_000
  }
  #self.levels.with_indifferent_access!
  self.level_order = [:hated, :hostile, :unfriendly, :neutral, :friendly, :honored, :revered, :exalted]

  def level
    level_order.reverse_each do |l|
      return l if value >= levels[l]
    end
    :hated
  end

  level_order.each do |name|
    define_method("#{name}?") do
      level == name
    end
  end

  def positive?
    [:friendly, :honored, :revered, :exalted].include?(level)
  end

  alias pos? positive?

  def negative?
    [:unfriendly, :hostile, :hated].include?(level)
  end

  alias neg? negative?

  def to_i
    value
  end

  def to_sym
    level
  end

  def to_s
    level.to_s
  end

  def self.num_for_next_lever(num_for_now)
    case num_for_now
    when -1000...0
      then return  0-num_for_now
    when 0...100
      then return 100-num_for_now
    when 100...500
      then return 500-num_for_now
    when 500...1000
      then return 1000-num_for_now
    when 1000...3000
      then return 3000-num_for_now
    end
    if num_for_now < -1000
     return  0-num_for_now
    end
    if num_for_now > 3000
      return 0
    end
  end

  def self.level_distance(rep1, rep2)
    level_order.index(rep1.to_sym) - level_order.index(rep2.to_sym)
  end

  def gain(amount, post, reason)
    transaction do
      lock!
      if self.value
        self.value += amount
      else
        self.value = amount
      end
      logs.create! :amount => amount,:group_id => (post.group_id || post.topic.group_id), :post_id => post.id.to_s, :user_id => user_id, :reason => reason
      save!
    end
  end

  protected
end

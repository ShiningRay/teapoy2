# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: salaries
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  amount     :integer
#  type       :string(255)
#  created_on :date
#  status     :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Salary < ActiveRecord::Base
  #self.abstract_class = true
  self.store_full_sti_class = false
  belongs_to :user
  validates_uniqueness_of :created_on, :scope => [:user_id, :type]
  #validates_presense_of :type
  class_attribute :default_amount
  before_validation :calc_amount
  #default_value_for( :created_on ){ Date.today }
  default_scope -> { order('created_on desc') }
  scope :paid, lambda { where(:status => 1) }
  scope :unpaid, lambda { where(:status => 0) }
  validates :amount, :numericality => {:greater_than => 0}
  #alias_method :original_amount, :amount
  #def amount
  #  original_amount || make
  #end

  def after_initialize
    self.created_on ||= Date.today
  end


  def posts
    Post.where(user_id: user.id)
  end

  def top_posts
    posts.top
  end

  def today_posts
    posts.on_date(created_on)
  end

  def paid!
    transaction do
      lock!
      if unpaid?
        user.gain_credit amount, "#{self.class.name}-#{created_on}" if self.valid?
        self.status = 1
        save!
      end
    end
  end

  def paid?
    status == 1
  end

  def unpaid?
    status == 0
  end

  def make
    Date.today <= "2013-02-24".to_date ? 3 * default_amount : default_amount
  end

  def self.cast(name)
    case name
    when String, Symbol
      Salary.const_get(name.to_s.classify)
    when Class
      name
    end
  end
  def self.make_salary(yesterday)
    User.find_each(:conditions => ["updated_at >= ?", yesterday.beginning_of_day]) do |u|
      u.make_salary('daily_article', yesterday)
      u.make_salary('daily_comment', yesterday)
      u.make_salary('daily_rating', yesterday)
      u.make_salary('daily_sofa', yesterday)
      Salary::BirthdaySurprise.make(u)
      # u.make_rating_salary(Date.today-1)
    end
    Salary::DailyScore.make(yesterday)
  end
  def self.make_yesterday_salary(yesterday =  Date.yesterday)
    make_salary yesterday
  end

  def self.make_missing_salary
    User.where('id > 0').find_each do |u|
      sa = u.salaries.order('created_at asc').first
      s = u.created_at
      s = u.articles.first.created_at unless s
      if sa.created_at > s
        s = s.to_date
        e = sa.created_at.to_date
        s.upto(e) do |d|
          %w(daily_article daily_comment daily_score).each do |i|
            u.make_salary(i, d)
          end
          Salary::DailyScore.make(d)
        end
      end
    end
  end

  def calc_amount
    self.amount ||= make
  end

  # calc salary with unit_cost * count
  class Count < Salary
    #self.abstract_class = true
    class_attribute :unit_cost
    self.unit_cost = 0
    def count
      raise 'Implement it first'
    end
    def make
       amount = unit_cost * count
       Date.today <= "2013-02-24".to_date ? 3 * amount : amount
    end
  end

  # count style salary but with a maximum
  class CountWithMaximum < Count
    #self.abstract_class = true
    class_attribute :maximum
    def make
      [maximum, super].min
    end
  end
end

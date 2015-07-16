# coding: utf-8
# == Schema Information
#
# Table name: rewards
#
#  id          :integer          not null, primary key
#  rewarder_id :integer          not null
#  post_id     :integer          not null
#  winner_id   :integer          not null
#  amount      :integer
#  anonymous   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_rewards_on_rewarder_id_and_post_id  (rewarder_id,post_id) UNIQUE
#

class Reward < ActiveRecord::Base
  # attr_accessible :amount, :winner_id, :spender_id
  attr_accessor :no_charge
  belongs_to :rewarder, class_name: 'User'
  belongs_to :winner, class_name: 'User'
  belongs_to :post

  validates :amount, :numericality => {:only_integer => true, :greater_than => 0}
  validates_uniqueness_of :rewarder_id, :scope => :post_id
  validates_each :rewarder_id do |model, attr, val|
    Rails.logger.debug "#{model.inspect} #{attr.inspect} #{val.inspect}"
    model.errors.add(attr, 'cannot reward to yourself') if val == model.winner.id
  end

  before_create :charge_credit, unless: :no_charge

  def charge_credit
    transaction do
      rewarder.spend_credit amount, "reward @#{winner.login} in \##{post_id}"
      winner.gain_credit amount, "rewarded by @#{rewarder.login} in \##{post_id}"
    end
  end

  private :charge_credit
  def self.make(sender, post, amount, anonymous=false)
    create(rewarder_id: sender.id, post_id: post.id.to_s, winner_id: post.user_id, amount: amount, anonymous: anonymous)
  end
end

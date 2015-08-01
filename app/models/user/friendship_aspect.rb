# coding: utf-8
module User::FriendshipAspect
  extend ActiveSupport::Concern
  # def self.included(base)
#    base.has_many :friendships
#    base.has_many :followships, :class_name => 'Friendship', :foreign_key => 'friend_id'
#    base.has_many :friends,
#      :through => :friendships,
#      :source => :friend,
#      :uniq => true
#    base.has_many :followers,
#      :through => :followships,
#      :source => :user,
#      :uniq => true
#  has_many :friendships
#  has_many :friends, :through => :friendships, :source => :user, :foreign_key => 'user_id'
#  has_many :followers, :through => :friendships, :source => :user, :foreign_key => 'friend_id'
  # end
  included do
    # has_many :followingships, -> { where(type: 'User') }, class_name: 'Subscription', foreign_key: :subscriber_id
    # has_many :followings, through: :followingships, source: :publication, source_type: 'User'
    has_many :followings, through: :subscriptions, source: :publication, source_type: 'User'
    has_many :followers, through: :subscribed_relationships, source: :subscriber
  end

  # def followings
  #   Subscription.by_publication(self).includes(:subscriber).collect{|s| s.subscriber }
  # end

  def follow(another_user)
    raise TypeError if another_user.class != User && another_user.class != Fixnum
    another_user = User.find another_user if another_user.is_a?(Fixnum)
    subscribe(another_user)
    #Friendship.create :user_id => self.id, :friend_id => another_user.id
#    Notification.create :user_id => another_user.id, :type => 'Follow', :content => nil
#  rescue ActiveRecord::StatementInvalid => e
    #raise e unless e.message.index('Duplicate')
  end

  def unfollow(another_user)
    unsubscribe(another_user)
  end

  def following?(another_user)
    has_subscribed?(another_user)
  end
end

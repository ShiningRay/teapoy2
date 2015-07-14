# 用户绑定的SNS账号的信息，包括关注和粉丝
class Identity < ActiveRecord::Base
  # field :provider, type: String
  # field :uid
  # field :data, type: Hash
  # field :nickname
  has_one :user_token
  has_many :followerships, class_name: 'IdentityFollowership', primary_key: 'uid', foreign_key: 'uid'
  has_many :followers, class_name: 'Identity', through: :followerships, source: :follower
  # has_many :followings, class_name: 'Identity'
  # index({uid: 1, provider: 1}, {unique: true})

  before_save do
    self.uid = self.uid.to_i if uid =~ /\A\d+\z/
  end

  after_create do
    # delay.grab_info
  end

  # maybe refactor info
  def grab_info
    self.data = user_token.client.users.show uid: uid
  end

  def grab_followers
    ids = Set.new
    next_cursor = 0
    loop do
      res = user_token.client.friendships.followers_ids uid: uid, cursor: next_cursor, count: 5000
      ids += res['ids']
      break if res['next_cursor'] == 0
      next_cursor = res['next_cursor']
    end

    self.following_ids = ids
  end

  def grab_followings
    ids = Set.new
    next_cursor = 0
    loop do
      res = user_token.client.friendships.friends_ids uid: uid, cursor: next_cursor, count: 5000
      ids += res['ids']
      break if res['next_cursor'] == 0
      next_cursor = res['next_cursor']
    end

    self.follower_ids = ids
  end
end
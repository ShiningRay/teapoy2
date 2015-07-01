# coding: utf-8
# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  login                     :string(255)      not null
#  email                     :string(255)      not null
#  crypted_password          :string(255)      not null
#  salt                      :string(255)      not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  remember_token            :string(255)      default(""), not null
#  remember_token_expires_at :datetime
#  activated_at              :datetime
#  avatar_file_name          :string(255)
#  avatar_content_type       :string(255)
#  avatar_file_size          :integer
#  avatar_updated_at         :datetime
#  state                     :string(255)      default("passive")
#  deleted_at                :datetime
#  name                      :string(100)
#  persistence_token         :string(255)      not null
#  login_count               :integer          default(0)
#  current_login_at          :datetime
#  last_login_at             :datetime
#  last_request_at           :datetime
#  current_login_ip          :string(255)
#  last_login_ip             :string(255)
#  perishable_token          :string(255)      default(""), not null
#  avatar_fingerprint        :string(255)
#

# User defined here

class User < ActiveRecord::Base
  include Tenacity
  class NotAuthorized < StandardError
  end

  include Redis::Objects
  include FriendshipAspect
  include MessageAspect
  include BalanceAspect
  include BadgeAspect
  include ReputationAspect
  include Authorization
  include MembershipAspect
  include RatingAspect
  include ReadStatusAspect
  include NotificationAspect
  include Privilege
  include AntiSpam
  harmonize :name
  include SubscriberAspect
  include RewardAspect
  include AvatarAspect
  include AuthenticationAspect

  # ---------------------------------------
  # The following code has been generated by role_requirement.
  # You may wish to modify it to suit your need
  t_has_many :topics
  has_many :name_logs
  t_has_many :posts
  has_many :lists
  has_many :tickets
  t_has_many :groups, foreign_key: 'owner_id'
  has_many :guestbooks, foreign_key: 'owner_id'
  has_many :stories, foreign_key: 'author_id'
  has_many :story_comments, foreign_key: 'author_id'
  has_many :likes
  t_has_one :profile, class_name: 'UserProfile'
  alias orig_profile profile

  def profile
    orig_profile || begin
     self.profile = UserProfile.new user_id: self.id
   end
  end
  # autosave
  after_save do
    profile.save if profile.changed?
  end

  def preferred_want_receive_notification_email
    profile.want_receive_notification_email
  end

  def preferred_want_receive_notification_email=(n)
    profile.want_receive_notification_email=n
  end

  def preferred_birthday
    profile.birthday.try(:to_date)
  end

  def preferred_birthday=(s)
    profile.birthday = s
  end

  def preferred_sex
    profile.sex
  end

  def preferred_sex=(s)
    profile.sex = s
  end

  def preferred_hometown
    profile.hometown
  end

  def preferred_hometown=(h)
    profile.hometown = h
  end

  #has_many :comments, class_name: 'Post', conditions: 'floor > 0'
  def comments
    posts.where(:floor.gt => 0)
  end

  #has_one :profile
  #has_many :quest_logs
  # has_many :client_applications
  # has_many :tokens, class_name: "OauthToken",
  #                   order: "authorized_at desc",
  #                   include: [:client_application]
  t_has_many :user_tokens

  scope :by_state, -> (status) { where(state: status) }

  def name_or_login
    name.blank? ? login : name
  end

  def clear_notification *args
    Notification.delete_all(user_id: id, key: args.join('.'))
  end

  def self.find_by_login_or_email(login)
    find_by_login(login) || find_by_email(login) || find_by_name(login)
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserNotifier.password_reset_instructions(self).deliver
  end

  def self.deliver_mass_email(users,title,content)
    users.each do |user|
      user.deliver_email(title,content)
    end
  end

  def deliver_email(title,content)
    UserNotifier.send_to_someone(self,title,content).deliver
  end

  #handle_asynchronously :deliver_email  if  Rails.env.production?


  # ---------------------------------------
  validates :login, format: {
                      with: /\A[a-zA-Z0-9_-]+\z/,
                      allow_blank: true, allow_nil: true
                    },
                    uniqueness: {allow_blank: true, allow_nil: true},
                    length: { in: 3..50, allow_blank: true, allow_nil: true }
  #validates_presence_of     :login
 # validates_format_of       :login,     with: /\A[a-zA-Z0-9_-]+\z/,
 #                           allow_nil: true, allow_blank: true
 # validates_length_of       :login,    within: 3..16
  validates :name,  format: {
                      with: /\A[^[:cntrl:]\s\\<>\/&:]*\z/,
                      message: "avoid non-printing characters and \\&gt;&lt;&amp;/ please.".freeze},
                    length: {maximum: 15},
                    uniqueness: true,
                    presence: true

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  # attr_accessible :login, :email, :name, :password, :password_confirmation,
  #   :avatar,
  #   :preferred_want_receive_notification_email,
  #   :preferred_sex, :preferred_birthday,
  #   :preferred_hometown
  # attr_protected :login
  #attr_accessor :receive_notification_email

  #def ensure_profile
  #  profile ? profile : create_profile
  #end

  def self.guest
    find_by_login('guest') || User.new(login: 'guest', name: 'Guest', email: 'guest@bling0.com').freeze
  end

  def rename new_name
    result = false
    transaction do
      lock!
      name_logs.create name: self.name
      self.name=new_name
      if self.valid?
        spend_credit(200, 'change-name')
        save!
        result = true
      end
    end
    result
  end

  #####{{{{
  def forget_me
    self.remember_token_expires_at = ''
    self.remember_token            = ''
    save!(validate: false)
  end

  # user rate specific topic
  def has_badge?(badge)
    case badge
    when Badge
      badges.find_by_id(badge.id)
    when Fixnum
      badges.find_by_id(badge)
    when String
      badges.find_by_name(badge)
    end
  end

  def to_param
    login ? login.downcase : id.to_s
  end

  def self.wrap!(obj)
    case obj
    when nil
      guest
    when String
      u = find_by_id!(obj) if obj =~ /\A\d+\z/
      u || find_by_login!(obj)
    when User
      obj
    else
      find(obj)
    end
  end

  def self.wrap(obj)
    case obj
    when nil
      guest
    when String
      u = find_by_id(obj) if obj =~ /\A\d+\z/
      u || find_by_login(obj)
    when User
      obj
    else
      find(obj)
    end
  end

  def self.find_all_by_id(ids)
    where(id: ids).to_a
  end

  def as_json(opt={})
    opt ||= {}
    opt.reverse_merge!({only: [:login, :name]})
    json = super(opt)
    json['avatar_url'] = avatar.small.url
    json
  end

  def badges_html
   result =""
   badges.each do |badge|
    result << "<span class=\'#{badge.name}\'>#{badge.title}</span>"
   end
   result
  end

  ##
  # Public - Test if user is the original author of the topic
  # @param topic [Topic]

  def own_topic?(topic)
    topic.read_attribute(:user_id) == self.id
  end
  alias own_post?  own_topic?

  def weixin_user
    Weixin::User.where(user_login: login).first
  end

  protected

  #before_save :change_to_pending_when_email_change
  def change_to_pending_when_email_change
    if active? and email_changed?
      self.state = 'pending'
      self.make_activation_code
      UserNotifier.signup_notification(self).deliver
    end
  end

end

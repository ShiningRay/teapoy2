# -*- coding: utf-8 -*-

class Group #< ActiveRecord::Base
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable
  disable_tags_index!
  include Tenacity

  #acts_as_nested_set
  include AntiSpam
  auto_increment :_id
  field :alias, type: String
  field :name, type: String
  field :description, type: String
  field :private, type: Boolean, default: false
  field :feature, type: Boolean, default: false
  field :hide, type: Boolean, default: false
  field :domain, type: String
  field :status, type: String
  field :theme, type: String
  embeds_one :options, class_name: 'GroupOptions', autobuild: true
  accepts_nested_attributes_for :options
  #acts_as_publisher
  # paginates_per 30
  # acts_as_taggable
  # attr_readonly :alias
  has_many :articles
  #has_many :public_articles, class_name: 'Article', conditions: {status: 'publish'}
  def public_articles
    articles.public_articles
  end
  #has_many :pending_articles, class_name: 'Article', conditions: {status: 'pending'}
  def pending_articles
    articles.pending
  end

  t_belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :posts
  #has_many :memberships
  field :member_ids, type: Array, default: []
  #has_many :members, class_name: 'User', select: "memberships.group_id, memberships.role as membership_role, users.*", through: :memberships, source: :user
  #has_many :pending_members, class_name: 'User', through: :memberships, source: :user, conditions: "memberships.role = 'pending'"
  #validates_
  def members
    @members ||= User.where(id: member_ids).to_a
  end
  validates_uniqueness_of :name
  validates_presence_of :name
  validates_format_of :alias, with: /\A[a-zA-Z_][a-zA-Z0-9_]{2,}\z/, allow_nil: false, allow_blank: false
  validates_uniqueness_of :alias
  index({name: 1}, {unique: true})
  index({alias: 1}, {unique: true})
  mount_uploader :icon, AvatarUploader, mount_on: :icon_file_name

  scope :public_groups, -> { where(private: false) }
  scope :private_groups, -> { where(private: true) }
  #scope :open_groups, -> { where(status: "open") }
  scope :hide_groups, -> { where(hide: true) }
  scope :not_pending, -> { where(:status.ne => 'pending') }
  scope :not_show_in_list, -> { where(hide: true).or(private: true) }
  scope :latest, -> { order_by(:created_at.desc) }

  harmonize :name, :description

  after_create :create_owner_membership

  def self.all_articles
    articles.unscoped
  end

  def self.find_by_alias(a, opt = {})
    where(:alias => a).first
  end

  def self.find_by_alias!(a, opt = {})
    where(:alias => a).first!
  end

  def create_owner_membership
    owner.join_group(self) if owner
  end

  before_create :lowercase_alias

  def merge_with(other_group)
    transaction do
      articles.each do |article|
        article.move_to other_group
      end
      members.each do |user|
        user.quit_group(self)
        user.join_group(other_group)
      end
    end
  end
  def lowercase_alias
    self.alias= self.alias.downcase
  end

  def recent_hottest_article
    public_articles.hottest.first
  end

  def preferred_guest_can_reply?
    false
  end

  def preferred_guest_can_post?
    false
  end

  def to_param
    self.alias
  end
  # FIXME: use mongoid query
  def self.clear_self
    self.all.each do |g|
      unless Article.exists?(["group_id = ? and created_at > ? and created_at < ?",g.id,1.day.ago,Time.now])
        g.update_attributes!(status:"close")
      end
    end
  end

  def self.update_scores
    today = Date.today
    Group.each do |g|
      g.inc(:score => g.articles.by_date(today).sum(:score))
    end
  end

  def subscribers
    Subscription.where(publication_type: 'Group', publication_id: id).includes(:subscriber).map{|s|s.subscriber}
  end

  def preferred_articles_need_approval?
    options.articles_need_approval
  end

  def preferred_membership_need_approval?
    options.membership_need_approval
  end

  def preferred_only_member_can_reply?
    options.only_member_can_reply
  end

  def self.meta_group
    find(0)
  end

  def self.wrap(obj)
    case obj
    when Group
      obj
    when Fixnum
      find_by_id obj
    when String
      find_by_alias obj
    end
  end

  def self.wrap!(obj)
    case obj
    when Group
      obj
    when Fixnum
      find obj
    when String
      find_by_alias! obj
    end
  end

  def to_post
    a = to_article
    a.top_post || a.build_top_post
  end

  def to_article
    a= self.class.meta_group.articles.featured.find_or_initialize_by(slug: self.alias)
    if a.new_record?
      a.group_id = 0
      a.build_top_post
      a.status='feature'
      a.title = a.slug
      a.save!
    end
    a
  end

  def norm_hints
    return @norm_hints if @norm_hints
    @norm_hints = Article.unscoped.where(group_id: id).find_or_initialize_by slug: 'new'
    @norm_hints.build_top_post if @norm_hints.top_post.blank?
    @norm_hints.status = 'private' if @norm_hints.new_record?
    @norm_hints.save! if @norm_hints.changed?
    @norm_hints.top_post.save! if @norm_hints.top_post.changed?
    @norm_hints
  end

  def self.find_by_domain(domain)
    where(domain: domain).first
  end

  def self.find_all_by_id(ids)
    where(:id.in => ids).all
  end

  def self.find_by_id(id)
    where(id: id).first
  end

  def self.find_by_alias!(a)
    find_by alias: a
  end

  def self.find_by_alias(a)
    where(alias: a).first
  end

  def self.migrate_from_mysql_to_mongo(start=0)
    conn = ActiveRecord::Base.connection
    loop do
      groups = conn.select "select * from groups where id > #{start} limit 1000"
      break if groups.size == 0
      groups.each do |group|
        start = group['_id'] = group.delete('id')
        pref = {}
        conn.select( "select * from preferences where owner_id=#{start} and owner_type='Group'").each do |row|
          pref[row['name']] = (pref['value'] == '0' ? nil : pref['value'])
        end
        group['private'] = group['private'] == 1
        group['feature'] = group['feature'] == 1
        group['hide'] = group['hide'] == 1
        group['options'] = YAML.load(group['options']).merge(pref) rescue nil
        Group.collection.insert(group)
      end
    end
    session = Mongoid.default_session
    session[:sequences].find(seq_name: 'group__id').upsert(seq_name: 'group__id', number: start+1)
    Group.collection.insert :_id => -1, :alias => 'users', :name => 'users'
    Group.collection.insert :_id => 0, :alias => 'groups', :name => 'groups'
  end


  def self.migrate_taggings
    conn = ActiveRecord::Base.connection
    taggings = conn.select "select * from taggings inner join tags on taggings.tag_id = tags.id where taggable_type like 'Group'"
    taggings.each do |tagging|
      group = Group.find tagging['taggable_id']
      group.add_to_set(:tags_array => tagging['name'])
    end
  end
end

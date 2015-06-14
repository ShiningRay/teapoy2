# coding: utf-8
# Inbox
class Inbox
  include Mongoid::Document
  include Tenacity
  #include Mongoid::Timestamps
  t_belongs_to :group
  t_belongs_to :user
  belongs_to :article
  field :score,      type: Integer, default: 0
  field :read,       type: Boolean, default: false
  #field :post_ids,   type: Array,   default: []
  has_and_belongs_to_many :posts, inverse_of: nil
  field :repost_ids, type: Array,   default: []
  field :is_repost,  type: Boolean, default: false
  field :created_at, type: DateTime, default: -> { Time.now }
  index({article_id: 1},  {background: true})

  index({user_id: 1,
         article_id: -1}, {unique: true})
  index({user_id:    1,
         post_ids:   1}, { background: true})
  index({user_id:    1,
         created_at: -1}, {background: true})
  index({user_id:    1,
         repost_ids: 1}, { background: true})
  index({user_id:    1,
         score:      -1,
         created_at: -1}, {background: true})
  index({user_id:    1,
         read:       1}, {background: true})
  index({user_id:    1,
         read:       1,
         score:      1}, {background: true})
  validates_each :post_ids do |model, attr, val|
    if val
      model.errors.add(attr, 'type mismatch') unless val.is_a?(Array) #and val.all?{|i|i.is_a?(Integer)}
    end
  end

  scope :guest,    -> {where(user_id: 0)}
  scope :frontpage,-> {where(user_id: 0)}
  scope :nonguest, -> {where(:user_id.gt => 0)}
  scope :read,     -> {where(read: true)}
  scope :unread,   -> {where(read: false)}
  scope :neg,      -> {where(:score.lt => 0)}
  scope :pos,      -> {where(:score.gt => 0)}
  scope :lt1,      -> {where(:score.lt => 1)}
  scope :hottest,  -> {desc(:score)}
  scope :by_user,    -> (user) { where(user_id: User.wrap(user).id)}
  scope :by_article, -> (article) { where(article_id: Article.wrap(article).id) }



  def read?
    read === true
  end

  def read!
    self.score = 0
    self.post_ids = []
    self.read = true
    save!
  end

  def self.read!
    update_all(score: 0, post_ids: [], read: true)
  end

  def add_post(post)
    add_to_set :post_ids => post.id
  end

  def remove_post(post)
    pull :post_ids => post.id
  end

  def add_repost(post)
    add_to_set :repost_ids => post.id
  end

  after_create :increment_count
  def increment_count
    UserCount.create_or_inc(user_id)
  end

  after_destroy :decrement_count
  def decrement_count
    UserCount.create_or_inc(user_id, -1)
  end

  class << self
=begin
    def add_to_set(field, elem)
      collection.update(scoped.selector,
        {'$addToSet' => {field => val}}, {multi: true})
    end

    def add_all_to_set(fields)
      collection.update(scoped.selector,
        {'$addToSet' => fields}, {multi: true})
    end

    def inc(field, val)
      collection.update(scoped.selector, {'$inc' => {field => val}}, {multi: true})
    end
=end
    def add_post(post)
      add_to_set(:post_ids => post.id)
    end

    def remove_post(post_id)
      scoped.and(post_ids: post_id).pull(:post_ids => post_id)
    end

    def remove_repost(repost_id)
      scoped.and(repost_ids: repost_id).pull(:repost_ids => repost_id)
    end

    def add_repost(post)
      add_to_set(:repost_ids => post.id)
    end

    # Public:
    # if the item not exists in user's inbox, then create it
    #
    def deliver(user, post)
      user = User.wrap(user)
      post = Post.wrap(post)
      return logger.debug('deliver: cannot find post') unless post
      return logger.debug('deliver: cannot find user') unless user
      return logger.debug('deliver: cannot find post.user') unless post.user
      return logger.debug('deliver: cannot find post.article') unless post.article
      return logger.debug('deliver: cannot find post.article.user') unless post.article.user
      return logger.debug('deliver: blacklisted') if user.disliked?(post.user) or user.disliked?(post.article.user)
      return logger.debug('deliver: user is not active') unless user.state.in?(%w(pending active))

      if post.is_a?(Repost)
        delay.deliver_repost(user.id, post.id)
      else
        res = where(user_id: user.id, article_id: post.article_id).find_and_modify({
                    '$inc'      => {score: Score.again(post, user)},
                    '$addToSet' => {post_ids: post.id},
                    '$set'      => {read: false}
                }, new: true)
        unless res
          Rails.logger.debug(
            user_id: user.id,
            article_id: post.article_id,
            group_id: post.group_id || post.article.group_id,
            post_ids: [post.id],
            read: false,
            score: Score.initial(post, user),
            created_at: post.article.created_at.utc
          )
          create!(
            user_id: user.id,
            article_id: post.article_id,
            group_id: post.group_id || post.article.group_id,
            post_ids: [post.id],
            read: false,
            score: Score.initial(post, user),
            created_at: post.article.created_at.utc
          )
        end
      end
    end

    # Public - deliver a repost into inbox queue
    # if the original post or repost of the original post have already been in the queue
    # then just update score of the inbox entry
    # when the repost is permitted to into the inbox
    # create an entry for it
    def deliver_repost(user, post)
      user = User.wrap(user)
      post = Post.wrap(post)
      return logger.debug('deliver: user is not active') unless user.state.in?(%w(pending active))
      return unless post.is_a?(Repost)
      art = post.original_post.reposted_articles_with_self
      # find if any repost or the original post has already exists in the inbox queue
      art.each do |article|
        next unless article
        next unless user.has_subscribed?(article.group)
        res = with(safe: true).where({
          user_id: user.id,
          article_id: article.id
        }).update_all({
          '$addToSet' => {repost_ids: post.id},
          '$inc'      => {score: Score.again(post, user)}
        })
        return if res['updatedExisting']  # updated successfully, then return
      end
      # nothing find, create a new item
      create!(
        user_id: user.id,
        article_id: post.article_id,
        group_id: post.group_id || post.article.group_id,
        post_ids: [post.id],
        repost_ids: [post.original_id],
        read: false,
        score: Score.initial(post, user)
      )
    end

    def deliver_score(post, rating)
      s = scoped
      post = Post.wrap(post)
      if post.is_a?(Repost)
        s = s.and(repost_ids: post.id)
      else
        s = s.and(article_id: post.article_id)
      end
      s.inc(score: Score.change(post, rating))
    end

    def frontpage_deliver(post, threshold=5)
      guest = User.guest
      article = post.article
      group = post.group || article.group
      return if group.private? or group.hide?
      return if Inbox.guest.where(article_id: article.id).exists?
      deliver(guest, post) if !guest.has_read?(article) and article.created_at >= 3.days.ago and post.score >= threshold
    end

    def set_score(user, post, score)
      user = User.wrap(user)
      post = Post.wrap(post)
      item = where( user_id: user.id, article_id: post.article_id).first
      return unless item
      item.score = score
      yield item if block_given?
      item.save!
      item
    end

    def read!
      update_all(read: true, post_ids: [], score: 0)
    end

    def bulk_mark_read(user_id, *ids)
      s = where(user_id: user_id).any_in(article_id: ids.flatten)
      s.read!
      s.only(:user_id, :article_id).find_each do |i|
        i.user.mark_read(i.article, 0) if i.article
      end
    end
    def mark_all_as_read
      find_each do |i|
        i.user.mark_read(i.article, 0) if i.user
      end
      destroy_all
    end

    def decay(score)
      score * 0.9
    end

    # lower score for those items exists longer in inbox
    def decay_score!
      nonguest.read.find_each do |item|
        item.score = decay(item.score).to_i
        item.save!
      end
      guest.find_each do |item|
        item.score = decay(item.score).to_i
        item.save!
      end
      #evict!
    end

    # remove inbox items which score is below certain threshold
    def evict!
      puts nonguest.read.lt1.destroy_all     # for normal users, only evict read items that score is low
      guest.lt1.each do |i|
          User.guest.mark_read i.article rescue nil
      end
      guest.lt1.where(:created_at.lt => 1.day.ago.utc).destroy_all
    end

    def cleanup
      find_each do |item|
        item.destroy unless item.article && item.article.status != 'deleted'
      end
    end
  end

  def self.find_each &block
    s = scoped
    limit = 1000
    offset = 0
    item_count = s.count
    while item_count > 0
      puts offset
      puts item_count
      results = s.limit(limit).skip(offset)
      results.each &block
      offset += limit
      item_count -= limit
    end
  end

  # for the users who haven't logged in for 1 months, empty their inbox
  #
  def self.remove_outdated
    User.where('last_login_at < ?', 1.month.ago).find_each do |user|
      Inbox.by_user(user).delete_all
      Inbox::UserCount.by_user(user).reset_count
    end
  end

  protected
  before_validation :unique_post_ids
  def unique_post_ids
    self.post_ids.uniq! unless post_ids.blank?
  end
end

# coding: utf-8
module User::ReadStatusAspect
  extend ActiveSupport::Concern

  included do
    has_many :read_statuses
  end

  def read_status_cache
    @read_status_cache ||= {}
  end

  # Public check if user has read some article
  #
  # article - Article to check
  #
  # Return a Integer stands for the max post floor id which user has already read
  def has_read_article?(article)
    article= Article.wrap(article)
    aid = article.id
    read_status_cache[aid] ||= read_statuses.where(:article_id => aid).select(:read_to).first.try(:read_to)
  end

  # Public: check if user has truly read some article.
  # It means that the user didn't click "dismiss" or "mark as read"
  #
  # article - the Article to check
  #
  # Return a Boolean true or false
  def has_truly_read_article?(article)
    r = has_read_article?(article)
    r && r.to_i >= 0
  end

  # Public: check if user has only glanced some article.
  # It means that the user "dismiss" or "mark as read"
  #
  # article - the Article to check
  #
  # Return a Boolean true or false
  def has_glanced_article?(article)
    has_read_article?(article).to_i < 0
  end

  # Public: check if user has only glanced some article.
  # It means that the user "dismiss" or "mark as read"
  #
  # article - the Article to check
  #
  # Return a Boolean true or false
  def has_read_post?(post)
    post = Post.wrap(post)
    return false unless post.floor
    aid = post.article_id
    read_status_cache[aid] ||= has_read_article?(aid)
    read_status_cache[aid] && read_status_cache[aid] >= post.floor
  end

  # Public: Update the user's read status
  #
  # article - the Article to read
  # floor   - Integer stands for which floor read to
  #
  # Return nothing
  def mark_read(article, floor=nil)
    floor ||= article.posts.size - 1
    return unless article.is_a?(Article)
    s = ReadStatus.find_or_create_by(user_id: id, article_id: article.id)
    s.read_to = floor if floor > s.read_to
    s.save!
  end

  def mark_article_as_read(article, floor=0)
    aid = article
    article = Article.wrap(article)
    return Rails.logger.info{"Cannot find article #{aid}"} unless article
    mark_read(article, floor)
    notifications.by_scope(:reply).by_subject(article).read!
    Inbox.where(:user_id => id, :article_id => article.id).read!
  end

  def mark_group_as_read(group)
    subscription_of(group).try(:mark_as_read!)
  end

  def bulk_mark_read(article_ids)
    return if article_ids.blank?
    article_ids.each do |i|
      read_statuses[id]  = 0 unless read_statuses[id]
    end
  end

  # Public: batch load read_status for articles
  #
  # article - Array for Article / Post to check
  #
  # Return an Array for read status
  def has_read?(*articles)
    articles.flatten!
    articles.compact!

    raise ArgumentError.new('need arguments') if articles.size == 0
    article = articles.first

    return article.is_a?(Post) ? has_read_post?(article) : has_read_article?(article) if articles.size == 1

    if article.is_a?(Post)
      posts = articles
      aids = post.collect{|p|p.article_id}.uniq
      s = has_read_article?(aids)
      return Hash[post.collect{|p| [p.id, has_read_post?(p)]}]
    end

    if article.is_a?(Article)
      ids = articles.map { |e| e.id }
    else
      ids = articles
    end

    read_statuses.where(:article_id => ids).select(%w(article_id read_to)).each do |i|
      read_status_cache[i.article_id] = i.read_to
    end
    #read_status_cache.merge! bulk_get(ids)
    if article.is_a?(Article)
      articles.each do |o|
        read_status_cache[o.id]=false unless read_status_cache.include?(o.id)
      end
    else
      articles.each do |o|
        read_status_cache[o]=false unless read_status_cache.include?(o)
      end
    end
    return read_status_cache
  end
end

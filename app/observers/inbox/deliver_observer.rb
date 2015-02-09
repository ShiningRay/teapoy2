# coding: utf-8
class Inbox::DeliverObserver < Mongoid::Observer
  observe :post

  def after_publish(post)
    return unless post and post.article
    self.class.delay.deliver(post.id) if post.article.status == 'publish'
  end

  def after_destroy(post)
    return unless post.is_a?(Post)
    #article = post.article
    if post.top?
      self.class.delay.remove_article post.article_id
    else
      self.class.delay.remove_post post.article_id, post.id
    end
  end

  class << self
    def remove_article(article_id)
      Inbox.delete_all(:article_id => article_id)
    end

    def remove_post(article_id, post_id)
      Inbox.where(:article_id => article_id).remove_post(post_id)
    end

    def deliver(post)
      post = Post.wrap(post)
      owner = post.original_user
      article = post.article
      group = post.group
      return unless group
      return if article.blank? or article.status != 'publish'
      if post.top?
        #Rails.logger.debug {"Article deliver #{group.subscribers.size}"}
        deliver_proc = Proc.new do |user|
          Rails.logger.debug {user.name_or_login}
          Inbox.deliver user.id, post.id
        end
        group.subscribers.each(&deliver_proc)
        owner.followers.each(&deliver_proc) unless post.anonymous?
      else
        #Rails.logger.debug {"Comment deliver #{article.subscribers.size}"}
        article.subscribers.each do |user|
          Rails.logger.debug {user.name_or_login}
          Inbox.deliver user.id, post.id
        end
      end
    end
  end
end

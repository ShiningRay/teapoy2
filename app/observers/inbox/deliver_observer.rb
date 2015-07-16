# coding: utf-8
class Inbox::DeliverObserver < ActiveRecord::Observer
  observe :post

  def after_publish(post)
    return unless post and post.topic
    self.class.delay.deliver(post.id) if post.topic.status == 'publish'
  end

  def after_destroy(post)
    return unless post.is_a?(Post)
    #topic = post.topic
    if post.top?
      self.class.delay.remove_topic post.topic_id
    else
      self.class.delay.remove_post post.topic_id, post.id
    end
  end

  class << self
    def remove_topic(topic_id)
      Inbox.delete_all(:topic_id => topic_id)
    end

    def remove_post(topic_id, post_id)
      Inbox.where(:topic_id => topic_id).remove_post(post_id)
    end

    def deliver(post)
      post = Post.wrap(post)
      owner = post.original_user
      topic = post.topic
      group = post.group
      return unless group
      return if topic.blank? or topic.status != 'publish'
      if post.top?
        #Rails.logger.debug {"Topic deliver #{group.subscribers.size}"}
        deliver_proc = Proc.new do |user|
          Rails.logger.debug {user.name_or_login}
          Inbox.deliver user.id, post.id
        end
        group.subscribers.each(&deliver_proc)
        owner.followers.each(&deliver_proc) unless post.anonymous?
      else
        #Rails.logger.debug {"Comment deliver #{topic.subscribers.size}"}
        topic.subscribers.each do |user|
          Rails.logger.debug {user.name_or_login}
          Inbox.deliver user.id, post.id
        end
      end
    end
  end
end

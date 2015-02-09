# encoding: utf-8
class Notification::MentionObserver < Mongoid::Observer
  observe :article, :post

  def after_publish(article)
    return unless article.is_a?(Article)
    send_mention(article.top_post)
  end

  #handle_asynchronously :after_publish if Rails.env.production?

  def after_numbered(post)
    return unless post.is_a?(Post)
    return unless post.article.status == 'publish'
    return unless post.floor and post.floor > 0
    send_mention(post)
  end
  #handle_asynchronously :after_create if Rails.env.production?

  def after_destroy(post)
    post = post.to_post
    Notification.where(:scope => 'mention',
      :source_ids => {'Post' => post.id}).each do |notification|
      notification.remove_source(post)
      notification.update_actors
    end
  end
  #handle_asynchronously :after_destroy if Rails.env.production?

  def send_mention(post)
    post.mentioned.each do |mentioned_user|
      Notification.send_to mentioned_user, 'mention', post.article, post.user, post
    end unless post.mentioned.blank?
  end
end

# coding: utf-8
class Inbox::ScoreObserver #< ActiveRecord::Observer
  # observe :rating
  # def after_commit(rating)
  #   return unless rating.send :transaction_include_action?, :create
  #   self.class.delay.deliver(rating.id)
  # end

  def self.deliver(rating_id)
    rating = Rating.find rating_id
    post = rating.post
    #score = post.score
    topic = post.topic
    return unless topic
    return if topic.status == 'private'
    if post.top?
      Inbox.frontpage_deliver(post)
      Inbox.where(:topic_id => topic.id).deliver_score(post, rating)
      #Inbox.where(:topic_id => topic.id).update_all(:score => post.score)
    end
  end
end

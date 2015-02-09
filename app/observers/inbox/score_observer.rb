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
    article = post.article
    return unless article
    return if article.status == 'private'
    if post.top?
      Inbox.frontpage_deliver(post)
      Inbox.where(:article_id => article.id).deliver_score(post, rating)
      #Inbox.where(:article_id => article.id).update_all(:score => post.score)
    end
  end
end

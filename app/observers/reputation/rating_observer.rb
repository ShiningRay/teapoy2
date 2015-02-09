# coding: utf-8
class Reputation::RatingObserver < Mongoid::Observer
  observe :rating

  def after_create(rating)
    return unless rater = rating.user
    return unless post  = rating.post
    return unless ratee = post.original_user
    return unless post.top?
    return if post.group_id <= 0
    group = post.group || post.article.group
     # don't calculation reputations in meta groups
    ratee_rep = ratee.reputation_in(group)
    rater_rep = rater.reputation_in(group)
    if rating.pos?
      d = rater.is_admin? || rater == group.owner ? 4 : Reputation.level_distance(rater_rep, ratee_rep)
      ratee.gain_reputation(d * 2, post, 'upvoted') if d > 0
    else
      rater.gain_reputation(-2, post, 'downvoting') unless rater.is_admin?
      ratee.gain_reputation(post.anonymous? ? -7 : -5, post, 'downvoted')
    end
  end

  #handle_asynchronously :after_create if Rails.env.production?
end

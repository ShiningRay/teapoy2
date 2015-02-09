# coding: utf-8
module Post::RatableAspect
  extend ActiveSupport::Concern
  included do
    t_has_many :ratings, dependent: :delete_all, foreign_key: 'post_id'
    field :pos_voter_ids, type: Array, default: []
    field :neg_voter_ids, type: Array, default: []
  end

  module ClassMethods
    def rated? user, post_ids
      user_id = user.is_a?(User) ? user.id : user
      result ={}
      Rating.select(:post_id).where(user_id: user_id, post_id: post_ids).each do |r|
        result[r.post_id] = true
      end
    end

    def update_scores(post_id = nil)
      ((post_id || ENV['post_id']) ? Post.where('id > ?', ENV['post_id'].to_i) : Post).find_each do |p|
        transaction do
          count =  p.ratings.sum(:score)
          pos = p.ratings.where(score: 1).sum(:score)
          neg = p.ratings.where(score: -1).sum(:score)
          p.update_attributes!(score: count, pos: pos, neg: neg)
          p.article.update_attributes!(score: count) if p.floor == 0 and p.article
          print '.'
        end
      end
    end
  end

  def total_score
    score || 0 #pos - neg
  end

  def rated_by? user
    uid = user.is_a?(User) ? user.id : user
    return true if uid == author_id
    Rating.select(:id).where(user_id: uid, post_id: id)
  end

  def vote user_id, s
    Rating.make user_id, self, s
  end
end

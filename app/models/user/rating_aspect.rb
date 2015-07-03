# coding: utf-8
module User::RatingAspect
  extend ActiveSupport::Concern
  included do
    has_many :ratings
    # Cache mechenism, disabled because server load is very low
    # include User::RatingCache::Remote
    # include User::RatingCache::Local
    # include User::RatingCache::TypeCast

    # has_many :liked_posts, :through => :ratings, :source => :post, :conditions => 'ratings.score > 0'
    # has_many :disliked_posts, :through => :ratings, :source => :post, :conditions => 'ratings.score < 0'
  end

  # Rate score for post
  def rate score, post
    ratings.create :score => (score.is_a?(Integer) ? score : Rating.score_for(score)), :post_id => Post.wrap(post).id
  end

  def vote post, s
    Rating.make(self, post, s)
  end

  # if the user has rated the post?
  def has_rated? post
    # post.pos_voter_ids.include?(self.id)||post.neg_voter_ids.include?(self.id)
    ratings.where(:post_id => post.id.to_s).select('score').first.try(:score)
  end

  #
  def has_rated_with? post, score
    score = Rating.score_for(score) unless score.is_a?(Integer)
    has_rated?(post) == score
  end

  def ratings_for *post
    r = {}
    ratings.where(:post_id => post.collect{|i|i.id}).select('post_id, score').each do |i|
      r[i.post_id] = r.score
    end
    r
  end

  def rate_status(post)
    Rating.status_for(has_rated?(post))
  end

  def liked?(post)
    (r = has_rated?(post)) and r > 0
  end

  def like!(post)
    rate 1, post
  end

  def disliked?(post)
    (r = has_rated?(post)) and r < 0
  end

  def dislike!(post)
    rate -1, post
  end
  def cancel_dislike!(post)
    post = Post.wrap(post)
    r = post.ratings.find_by_user_id self.id
    r.destroy
  end

end

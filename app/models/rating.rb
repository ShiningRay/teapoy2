# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: ratings
#
#  id         :integer          not null, primary key
#  post_id    :string(24)       default("0"), not null
#  user_id    :integer          default(0), not null
#  score      :integer          default(0), not null
#  created_at :datetime         not null
#


class Rating < ActiveRecord::Base
  belongs_to :post#, touch: true
  belongs_to :user

  scope :pos, -> { where('ratings.score > 0') }
  scope :neg, -> { where('ratings.score < 0') }
  validates :user_id, :post_id, presence: true


  def pos?
    score > 0
  end

  def neg?
    score < 0
  end

  def self.make(user, post, score)
    user = User.wrap(user)
    post = Post.wrap(post)
    user_id = user.id
    post_id = post.id.to_s
    return false if post[:user_id] == user_id

    transaction do
      # post.lock!
      r = Rating.where(post_id: post_id, user_id: user_id).lock(true).first
      pos_change = 0
      neg_change = 0
      score_change = 0
      if r
        if r.score != score
          if r.score > 0
            pos_change = -1
          else
            neg_change = -1
          end
          score_change = -r.score
          r.score = score
          r.save!
        else
          return false
        end
      else
        create post_id: post_id,
          user_id: user_id,
          score: score
      end

      if score > 0
        pos_change += 1
        score_change += 1
      else
        neg_change += 1
        score_change -= 1
      end
      Post.where(id: post.id).update_all("pos = pos + #{pos_change}, neg = neg + #{neg_change}, score = score + #{score_change}")
    end
  rescue ActiveRecord::RecordNotUnique
    return false
  end

  #after_create :update_reputation
  def update_reputation
    votee = post.user
    group = post.group
    votee_rep = votee.reputation_in group
    voter_rep = user.reputation_in group
    rep += Reputation.level_distance(voter_rep, votee_rep)
    rep.save!
  end

  def self.status_for(score, like_text='likes', dislike_text='dislikes', unvoted_text='unvoted')
    case score
    when 1
      like_text
    when -1
      dislike_text
    else
      unvoted_text
    end
  end

  LIKE_NAMES=%W(up pos like liked)
  DISLIKE_NAMES=%W(dn neg down dislike disliked)

  def self.score_for(action_name)
    action_name=action_name.to_s
    if LIKE_NAMES.include?(action_name)
      1
    elsif DISLIKE_NAMES.include?(action_name)
      -1
    end
  end

  # after_commit( on: :create ) { Inbox::ScoreObserver.delay.deliver(id) }

  # validate :cannot_rate_to_self
  # def cannot_rate_to_self
  #   errors.add(:user_id) if user_id == post[:user_id]
  # end
end

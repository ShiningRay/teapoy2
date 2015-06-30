# coding: utf-8
class Poll < Post
  acts_as_top_post_only
  field :voters, type: Array, default: []
  field :questions, type: Array, default: []
  field :vote_count, type: Integer, default: 0
  field :stats, type: Hash, default: {}
  field :max_selection, default: 1
  field :min_selection, default: 1

  validate :questions_cannot_be_empty
  def questions_cannot_be_empty
    return errors.add(:questions, 'cannot be empty') if questions.blank?
    errors.add(:questions, 'must be more than one question') if questions.size <= 1
  end
  def single?
    max_selection == 1
  end

  def multiple?
    max_selection > 1
  end

  def question_content
    questions.join("\n")
  end

  def question_content=(new_content)
    self.questions=new_content.split(/[\r\n]+/)
    questions.compact!
    questions.reject!{|i| i.size == 0}
    questions.uniq!
  end

  def vote(index, voter=nil, save_now=true)
    index = index.to_i
    return unless questions[index]

    if voter
      voter = User.wrap voter
      return false if self.voters.include?(voter.id)
      self.voters << voter.id
      #voter.vote id, 1
    end
    stats[index] ||= 0
    stats[index] += 1
    self.vote_count += 1

    save! if save_now
  end

  def remove_vote(vote)
    c=vote.choice.to_i
    stats[c] -= 1 if c and stats[c]
    self.vote_count -= 1 if c
    self.voters.delete(vote[:user_id]) unless voters.blank?
    save!
  end

  def recalc!
    self.voters = []
    self.vote_count = 0
    self.stats = {}

    topic.comments.where(type: 'Vote').each do |vote|
      vote(vote.choice, vote.original_user, false)
    end

    save!
  end


  def voted_by?(user)
    user = User.wrap(user)
    topic.comments.where(user_id: user.id, type: 'Vote').exists?
  end

  def as_json(opts={})
    result = []
    questions.each_index do |c|
      result << [c+1,questions[c],stats[c] || 0]
    end
    result.sort{|a,b| b[2] <=> a[2]}
    #result.sort{|a,b| b[2] <=> a[2]}
    super(opts).merge(results: result)
  end
end

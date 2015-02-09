# coding: utf-8
class Vote < Post
  acts_as_children_only
  validates_parent_of Poll
  acts_as_unique_child

  field :choice

  after_create :update_poll_stat

  def update_poll_stat
    parent.vote(choice.to_i, self.original_user)
  end

  before_destroy :remove_poll_stat
  def remove_poll_stat
    parent.remove_vote(self) if parent
  end

  def choice_content
    parent.questions[choice.to_i]
  end
#  def as_json(opts)
#  end
end

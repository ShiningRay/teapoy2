class TopicPolicy < GroupPolicy
  attr_reader :topic
  def initialize(user, record)
    @topic = record
    super(user, topic.group)
  end

  def index?

  end

  def show?
    admin? || super && case
    when topic.published?
      topic_author? || super
    when topic.pending?, topic.private?
      topic_author? || group_owner?
    when topic.draft?
      topic_author?
    end
  end

  def create?
    member? and group.options
  end

  def update?
    topic_author? || group_owner? || admin?
  end

  def destroy?
    update?
  end

  def topic_author?
    !anonymous? && user.id == topic.user_id
  end
end

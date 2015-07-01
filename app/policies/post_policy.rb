class PostPolicy < TopicPolicy
  attr_reader :post
  def initialize(user, record)
    @post = record
    super(user, @post.topic) if @post.topic
  end

  def create?
    topic.comment_status == 'open'
  end

  def update?
    false
  end

  def destroy?
    admin? || post_author? || topic_author? || group_owner?
  end

  protected
  def post_author?
    user && user.id == post.user_id
  end
end

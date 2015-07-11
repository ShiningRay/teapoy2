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


  # TODO:

  def create?
    member? and group.options

    ### refactor below add them to policy
    # if !status.blank? and logged_in? and current_user.own_group?( @group) or current_user.is_admin?
    #   @topic.status = status || 'publish'
    # else
    #   @topic.status = @group.preferred_topics_need_approval? ? 'pending' : 'publish'

    #   if @group.options.only_member_can_post and !current_user.is_member_of?(@group)
    #     error_return.call('只有小组成员才能在这里发贴')
    #   end
    # end
    # error_return.call('未激活用户暂时不能发帖') unless current_user.active? or @group.preferred_guest_can_post?

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

class PostPolicy < TopicPolicy
  attr_reader :post
  def initialize(user, record)
    @post = record
    super(user, @post.topic) if @post.topic
  end

  def create?
    topic.comment_status == 'open'
    # # TODO: refactor and enable below code
    # unless logged_in? #or @group.preferred_guest_can_reply?

    # # TODO: refactor and enable below code
    # if group.options.only_member_can_reply?
    #   unless logged_in?
    #     return_with_text.call("请登录")
    #   else
    #     if current_user.state != 'active'
    #       return_with_text.call(I18n.t('users.must_activate'))
    #     end
    #   end
    # end
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

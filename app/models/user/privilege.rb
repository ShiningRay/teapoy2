# coding: utf-8
module User::Privilege
  extend ActiveSupport::Concern
  included do
    has_and_belongs_to_many :roles
  end

  def guest?
    id == 0
  end
  alias anonymous? guest?

  def role_names
    roles.collect{|r|r.name}.join(' ')
  end
  # has_role? simply needs to return true or false whether a user has a role or not.
  # It may be a good idea to have "admin" roles return true always

  def has_role?(role_in_question)
    @_list ||= self.role_names
    return true if @_list.include?("admin")
    (@_list.include?(role_in_question.to_s) )
  end

  def is_admin?
    !guest? && has_role?('admin')
  end
  alias admin? is_admin?

  def is_publisher?
    !guest? && has_role?('publish')
  end

  def can_manage?(group)
    own_group?(group)
  end

  def can_delete?(article)

  end

  def own_group?(g)
    g.owner_id == id
  end

  def own?(obj)
    case obj
    when Topic
      own_topic?(obj)
    when Group
      own_group?(obj)
    else
      false
    end
  end

  def can_post_in?(group)
    #group.prefer
    group = Group.wrap group
    level = group.prefered_post_level
    rep = reputation_in(group)
    rep >= level
  end

  def can_reply_to?(post)
    post = Post.wrap(post)
    return false if post.topic.closed?
    group = post.group
    rep = reputation_in(group)
    level = group.prefered_reply_level
    rep >= level
  end

  def can_vote_up?(post)
    post= Post.wrap(post)
    group = post.group
    level = group.prefered_vote_up_level
    rep = reputation_in(group)
    rep >= level
  end

  def can_vote_down?(post)
    post= Post.wrap(post)
    group = post.group
    level = group.prefered_vote_down_level
    rep = reputation_in(group)
    rep >= level
  end
end

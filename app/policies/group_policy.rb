class GroupPolicy < ApplicationPolicy
  attr_reader :group
  def initialize(user, record)
    super
    @group = record
  end

  def index?
    super
  end

  def show?
    admin? || group_owner? || (group.private ? group_member? : super)
  end

  def update?
    group_owner?
  end

  protected
  def group_owner?
    user && user.id == group.owner_id
  end

  def group_member?
    user && user.is_member_of?(group)
  end
end

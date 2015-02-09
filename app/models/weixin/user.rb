class Weixin::User
  include Mongoid::Document
  field :uid, type: String
  field :name, type: String
  field :user_id, type: Integer
  field :session, type: Hash, default: {}
  index({user_id: 1}, {unique: true})
  validates :uid, :user_id, uniqueness: true

  def user
    @user ||= User.find_by_id(user_id)
  end

  def user=(new_user)
    self.user_id = new_user.id
    @user = new_user
  end
end

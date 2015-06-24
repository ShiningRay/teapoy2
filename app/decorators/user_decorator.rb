class UserDecorator < Draper::Decorator
  delegate_all

  def class_names
    @names ||= Rails.cache.fetch([object.login, 'class_names'], expires_in: 1.hour) do
      names = []
      names << "user-#{object.login}"
      names << "sex-#{object.profile.sex}" if object.profile.present? and object.profile.sex.present?
      names += object.roles.collect{|r| "role-#{r.name}"}
      names
    end
  end
end

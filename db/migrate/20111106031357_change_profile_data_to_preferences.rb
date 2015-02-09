# coding: utf-8
class ChangeProfileDataToPreferences < ActiveRecord::Migration

  class User < ActiveRecord::Base
  end

  class Profile < ActiveRecord::Base
    serialize :value, Hash
  end

  class Preference < ActiveRecord::Base

  end

  def change
    User.all.each do |u|
      profile = Profile.find_by_user_id(u.id)
      if profile && profile.value[:receive_notification_email] == false
       Preference.create(:name=>"want_receive_notification_email",:owner_id=>u.id,:owner_type=>"User",:value=>0)
      end
      u.save!
    end
  end
end

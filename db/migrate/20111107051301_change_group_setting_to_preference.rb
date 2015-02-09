# coding: utf-8
class ChangeGroupSettingToPreference < ActiveRecord::Migration

  class Group < ActiveRecord::Base
    serialize :options, Hash
  end

  class Preference < ActiveRecord::Base

  end

  def change
    Group.all.each do |g|
      g.options.each_pair do |key,value|
        if ["1",true,"true",1].include?(value)
          Preference.create(:name=>"#{key}",:owner_id=>g.id,:owner_type=>"Group",:value=>1)
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: user_profiles
#
#  id                              :integer          not null, primary key
#  user_id                         :integer          not null
#  sex                             :string(255)      default("")
#  birthday                        :date
#  hometown                        :string(255)
#  bio                             :string(255)
#  want_receive_notification_email :boolean          default(TRUE), not null
#
# Indexes
#
#  index_user_profiles_on_user_id  (user_id) UNIQUE
#

require 'rails_helper'

RSpec.describe UserProfile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

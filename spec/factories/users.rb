# coding: utf-8
# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  login                     :string(255)      not null
#  email                     :string(255)      not null
#  crypted_password          :string(255)      not null
#  salt                      :string(255)      not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  remember_token            :string(255)      default(""), not null
#  remember_token_expires_at :datetime
#  activated_at              :datetime
#  avatar_file_name          :string(255)
#  avatar_content_type       :string(255)
#  avatar_file_size          :integer
#  avatar_updated_at         :datetime
#  state                     :string(255)      default("passive")
#  deleted_at                :datetime
#  name                      :string(100)
#  persistence_token         :string(255)      not null
#  login_count               :integer          default(0)
#  current_login_at          :datetime
#  last_login_at             :datetime
#  last_request_at           :datetime
#  current_login_ip          :string(255)
#  last_login_ip             :string(255)
#  perishable_token          :string(255)      default(""), not null
#  avatar_fingerprint        :string(255)
#
# Indexes
#
#  email                            (email) UNIQUE
#  index_users_on_perishable_token  (perishable_token)
#  index_users_on_state             (state)
#  login                            (login) UNIQUE
#  remember_token                   (remember_token)
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
  	password { Forgery('basic').password }
  	password_confirmation { password }
    state 'pending'
    email { Forgery(:internet).email_address }
    login { Forgery(:internet).user_name }
    name { Forgery(:basic).text }
    persistence_token { Forgery('basic').text }

    trait :active do
      state 'active'
      activated_at { Time.now }
    end

    trait :pending do
      state 'pending'
    end

    trait :admin do
      roles { [create(:role, :admin)] }
    end

    trait :rich do
      association :balance, factory: :rich_balance
    end
    factory :rich_user, traits: [:rich]
    factory :active_user, traits: [:active]
    factory :admin, traits: [:admin]
  end
end

# coding: utf-8
# == Schema Information
#
# Table name: guestbooks
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  owner_id    :integer          not null
#  description :text(65535)
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_guestbooks_on_name      (name) UNIQUE
#  index_guestbooks_on_owner_id  (owner_id)
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :guestbook do

    sequence(:name) {|n| "guestbook#{n}"}
    association :owner, factory: :active_user

  end
end

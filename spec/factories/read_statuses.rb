# == Schema Information
#
# Table name: read_statuses
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  group_id   :integer
#  article_id :integer          not null
#  read_to    :integer          default(0)
#  read_at    :datetime
#  updates    :integer          default(0)
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :read_status do
    user
    group
    article
  end
end

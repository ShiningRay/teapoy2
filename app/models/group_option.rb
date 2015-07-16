# == Schema Information
#
# Table name: group_options
#
#  id                            :integer          not null, primary key
#  group_id                      :integer          not null
#  receive_group_email_frequency :string(255)      default("day")
#  only_member_can_view          :boolean          default(FALSE)
#  only_member_can_post          :boolean          default(FALSE)
#  membership_need_approval      :boolean          default(FALSE)
#  only_member_can_reply         :boolean          default(FALSE)
#  topics_need_approval          :boolean          default(FALSE)
#  comments_need_approval        :boolean          default(FALSE)
#  force_comments_anonymous      :boolean          default(FALSE)
#  force_anonymous               :boolean          default(FALSE)
#  encryption                    :boolean          default(FALSE)
#  score_algorithm               :string(255)
#  css                           :string(255)
#  seo_keywords                  :string(255)
#  seo_description               :string(255)
#  background                    :string(255)
#  background_style              :string(255)
#  guest_can_post                :boolean          default(FALSE)
#  guest_can_reply               :boolean          default(FALSE)
#
# Indexes
#
#  index_group_options_on_group_id  (group_id)
#

# group_option.rb
class GroupOption < ActiveRecord::Base
  belongs_to :group

end

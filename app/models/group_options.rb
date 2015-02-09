class GroupOptions
  include Mongoid::Document
  embedded_in :group
  field :receive_group_email_frequency, type: String, default:'day'
  field :only_member_can_view, type: Boolean, default: false
  field :only_member_can_post, type: Boolean, default: false
  field :membership_need_approval, type: Boolean, default: false
  field :only_member_can_reply, type: Boolean, default: false
  field :articles_need_approval, type: Boolean, default: false
  field :comments_need_approval, type: Boolean, default: false
  field :force_comments_anonymous, type: Boolean, default: false
  field :force_anonymous, type: Boolean, default: false
  field :encryption, type: Boolean, default: false
  field :score_algorithm, type: String
  field :css, type: String
  field :seo_keywords, type: String
  field :seo_description, type: String
  field :background, type: String
  field :background_style, type: String
  field :guest_can_post, type: Boolean, default: false
  field :guest_can_reply, type: Boolean, default: false
end

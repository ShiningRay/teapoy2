# == Schema Information
#
# Table name: groups
#
#  id                :integer          not null, primary key
#  name              :string(255)      not null
#  description       :string(255)
#  created_at        :datetime
#  alias             :string(255)
#  options           :text(65535)
#  owner_id          :integer
#  icon_file_name    :string(255)
#  icon_content_type :string(255)
#  icon_file_size    :integer
#  icon_updated_at   :datetime
#  private           :boolean          default(FALSE)
#  feature           :integer          default(0), not null
#  theme             :string(255)
#  status            :string(255)      default("open"), not null
#  score             :integer          default(0), not null
#  hide              :boolean          default(FALSE), not null
#  domain            :string(255)
#
# Indexes
#
#  index_groups_on_alias   (alias) UNIQUE
#  index_groups_on_domain  (domain) UNIQUE
#  index_groups_on_hide    (hide)
#

class GroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :icon
  has_one :owner
  # def as_json(opts = {})
  #   res = super({except:
  #     ([:options, :owner_id, :theme, :icon_content_type, :icon_file_name,
  #       :icon_file_size, :icon_updated_at, :created_at ] + Array(opts[:except])).uniq})
  #   #res[:options] = options.as_json
  #   res[:owner] = owner.login
  #   i = {}
  #   i[:original] = icon.url
  #   icon.styles.each_pair do |name, file|
  #     i[name] = file.attachment.url(name)
  #   end
  #   res[:icon] = i
  #   #res[:posts_count] = posts.size
  #   res[:topics_count] = public_topics.size
  #   res[:members_count] = member_ids.size

  #   res
  # end
        # json = @group.as_json(:except=>[:feature, :hide, :private, :id,:score,:status,:owner])
        # json['group_url'] = group_topics_path(@group)
        # json['join_or_quit_group_url'] = join_group_path(@group)
        # json['join_or_quit_text'] = "加入小组"
        # json['new_topic_path'] = new_topic_path(@group)
        # if logged_in? && current_user.is_member_of?(@group)
        #     json['join_or_quit_group_url'] = quit_group_path(@group)
        #     json['join_or_quit_text'] = "退出小组"
        # end
end

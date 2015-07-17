# == Schema Information
#
# Table name: topics
#
#  id             :integer          not null, primary key
#  tag_line       :string(255)
#  user_id        :integer          default(0), not null
#  created_at     :datetime
#  status         :string(7)        default("pending"), not null
#  group_id       :integer          default(0), not null
#  comment_status :string(15)       default("open"), not null
#  anonymous      :boolean          default(FALSE), not null
#  updated_at     :datetime
#  title          :string(255)
#  top_post_id    :integer
#  score          :integer          default(0)
#  posts_count    :integer          default(0)
#  views          :integer          default(0), not null
#  last_posted_at :datetime         not null
#  last_poster_id :integer
#
# Indexes
#
#  created_at                                          (group_id,status,created_at)
#  index_topics_on_group_id_and_status_and_updated_at  (group_id,status,updated_at)
#  index_topics_on_last_posted_at                      (last_posted_at)
#  status                                              (status,group_id,id)
#

class TopicSerializer < ActiveModel::Serializer
  attributes :id, :title, :anonymous, :status, :tag_line,
             :created_at, :slug, :score, :comments_count
  has_one :top_post, :user, :group
  # def as_json(opts={})
  #     except = ['anonymous', 'status', 'ip', 'tag_line', 'top_post_id', 'user_id', 'group_id']
  #     except += ['anonymous', 'status', 'ip'] if anonymous?
  #     res = super({except: except}.merge(opts))
  #     res['time_ago_in_words'] = time_ago_in_words(created_at)
  #     res['user'] = user.as_json unless anonymous?
  #     res['top_post'] = top_post.as_json
  #     res['title'] ||= ''
  #     res['slug'] ||= ''
  #     res['group'] = group.alias
  #     res['group_name'] = group.name
  #     res['status'] ||= ''
  #     res
  #   end
  # post = @topic.top_post

        # p = @topic.as_json
        # p['rate_status'] = logged_in? ? current_user.rate_status(post) : 'unvoted'
        # p['subscribe_status'] = 'subscribe'
        # p['subscribe_status'] = "unsubscribe" if logged_in? && current_user.has_subscribed?(@topic)
        # if p['top_post']
        #   p['top_post']['html'] =
        #   p['top_post']['class_names'] = post.class_names
        # end
end

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

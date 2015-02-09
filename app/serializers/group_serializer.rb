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
  #   res[:articles_count] = public_articles.size
  #   res[:members_count] = member_ids.size

  #   res
  # end
        # json = @group.as_json(:except=>[:feature, :hide, :private, :id,:score,:status,:owner])
        # json['group_url'] = group_articles_path(@group)
        # json['join_or_quit_group_url'] = join_group_path(@group)
        # json['join_or_quit_text'] = "加入小组"
        # json['new_article_path'] = new_article_path(@group)
        # if logged_in? && current_user.is_member_of?(@group)
        #     json['join_or_quit_group_url'] = quit_group_path(@group)
        #     json['join_or_quit_text'] = "退出小组"
        # end
end

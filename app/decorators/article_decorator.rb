class ArticleDecorator < Draper::Decorator
  delegate_all
  decorates_association :top_post
  decorates_association :user

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  def url
    h.article_path(object.group, object)
  end

  def author_name
    object.user.name
  end

  def author_link opt={}
    h.link_to author_name, object.user, opt
  end

  def content
    top_post.content
  end
end

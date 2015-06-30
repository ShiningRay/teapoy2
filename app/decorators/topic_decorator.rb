class TopicDecorator < Draper::Decorator
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
    h.topic_path(object.group, object)
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

  
  def class_names
    c = ['topic', 'hentry']
    c << "anonymous" if anonymous
    c << closed? ? "closed" : "open"
    c << status
    c << 'no-title' if title.blank?
    # c << 'empty' if posts.size == 0
    # c << 'no-comment' if posts.size == 1
    c
  end
end

class PostDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  def content
    RDiscount.new(h.convert_mention(h.sanitize object.content)).to_html.html_safe
  end

  def class_names
    c = ['post']
    c << (object.top? ? 'top_post' : (object.comment? && 'comment'))
    c << "floor-#{object.floor}"
    c << object.class.name.to_s.underscore unless object.class == Post
    if object.anonymous or object.user.blank?
      c += %w(anonymous user-Guest)
    else
      c += Array.wrap(user.class_names)
    end
    c << "topic-owner" if !object.anonymous and object.topic and !object.topic.anonymous and object.user_id == object.topic.read_attribute(:user_id)
    if object.score == 0
      c << 'zero'
    else
      c << (object.score > 0 ? 'pos' : 'neg')
    end
    #c << "comment-to-floor-#{parent_id}" if parent_id.to_i != 0
    #c.join(' ')
  end


  def plain_text
    (object.format == 'html' ? Nokogiri::HTML(object.content).text : object.content) || ''
  end
end

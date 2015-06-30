class StoryDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def author_name
    object.anonymous? ? '匿名用户' : object.author.name_or_login
  end

  def author_link
    object.anonymous? ? '匿名用户' : h.link_to( object.author.name_or_login, object.author )
  end

  def to_model
    object
  end
end

module StoriesHelper
  def story
    @decorated_story ||= @story.decorate
  end
end

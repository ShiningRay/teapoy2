module Topic::LastPostAspect
  extend ActiveSupport::Concern
  included do
    belongs_to :last_poster, class_name: 'User'
    before_save {
      self.last_posted_at ||= Time.now
    }
  end

  def reset_last_post_info(*post)
    p = posts.last

    if p
      self.last_posted_at = p.created_at
      self.last_poster_id = p.user_id
    else
      self.last_posted_at = created_at
      self.last_poster_id = nil
    end
    save
  end
end
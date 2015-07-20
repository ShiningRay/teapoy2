module Topic::StatusAspect
  extend ActiveSupport::Concern
  included do
    # field :status, type: String, default: 'pending'
    scope :by_status, ->(status) { where(status: status)}
    scope :public_topics, -> { where(:status => %w(publish public)) }
    scope :pending, -> {where(status: 'pending')}

    define_model_callbacks :publish, only: [:after]

    after_save do
      if status_was != 'publish' and status == 'publish'
        run_callbacks :publish do
          notify_observers(:after_publish)
          top_post.run_callbacks :publish if top_post
        end
      end
    end
  end

  def published?
    status == 'publish'
  end

  def pending?
    status == 'pending'
  end

  def draft?
    status == 'draft'
  end

  def private?
    status == 'private'
  end

  def publish!
    self.status = 'publish'
    save!
  end

end

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
end

module Post::CallbacksAspect
  extend ActiveSupport::Concern
  included do
    define_model_callbacks :publish, :only => [:after]
    after_publish do
      notify_observers(:after_publish)
    end
  end
end
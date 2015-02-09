class Post
  module DescribedTargetAspect
    extend ActiveSupport::Concern

    def described_target
      @described_target ||= begin
        if self['described_type'] && self['described_id']
          described_class = self['described_type'].safe_constantize
          described_class.find self['described_id']
        end
      end
    end

    def described_target=(new_target)
      @described_target = new_target
      self['described_type'] = new_target.class.name
      self['described_id'] = new_target.id
    end
  end
end
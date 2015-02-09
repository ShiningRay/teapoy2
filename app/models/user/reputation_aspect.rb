# coding: utf-8
module User::ReputationAspect
  extend ActiveSupport::Concern
  included do
    has_many :reputations, :autosave => true
    has_many :reputation_logs
  end
  module ClassMethods

  end

  #module InstanceMethods
    def reputation_in(group)
      group = Group.wrap!(group)
      reputations.where(:group_id => group.id).first_or_initialize
    end

    def reputations_in(*groups)
    end

    def gain_reputation(amount, post, reason)
      reputations.where(group_id: post.group_id || post.article.group_id).first_or_create.gain(amount, post, reason)
    end
  #end

end

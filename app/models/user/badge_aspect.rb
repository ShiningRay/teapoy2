# coding: utf-8
module User::BadgeAspect
  extend ActiveSupport::Concern
  module ClassMethods

  end


  def has_badge?(name)
    badges.include?(Badge.wrap(name))
  end


  included do
    has_and_belongs_to_many :badges
  end
end

# coding: utf-8
module User::SubscriberAspect
  extend ActiveSupport::Concern
  included do
    has_many :subscriptions, foreign_key: :subscriber_id, dependent: :delete_all
    has_many :subscribed_relationships, -> { where(publication_type: 'User') }, class_name: 'Subscription', foreign_key: :publication_id
    # include User::SubscriptionCache::Remote
    include User::SubscriptionCache::Local
    # include User::SubscriptionCache::TypeCast
  end

  def publications(type=nil)
    subscriptions.where(publication_type: type.to_s).collect{|i|i.publication}
  end

  # Returns trur/false if the provided object is a favorite of the users
  def has_subscribed?( publication )
    subscriptions.by_publication(publication).exists?
  end

  alias subscribed? has_subscribed?

  def subscribed_for?( *publication )
    r = {}
    publication.each do |p|
      r[[p.class.name, p.id]] = has_subscribed?(p)
    end
    r
  end

  def subscription_of(publication)
    subscriptions.by_publication(publication).first
  end

  # Sets the object as a favorite of the users
  def subscribe( publication )
    subscriptions.create(publication: publication) unless has_subscribed?(publication)
  rescue ActiveRecord::RecordNotUnique
  end

  # Removes an object from the users favorites
  def unsubscribe( publication )
    subscriptions.by_publication( publication ).delete_all
  end

private
  def method_missing(selector, *args, &block)
    if selector.to_s =~ /subscribed_([a-z_]*)/
      unless respond_to?(selector)
        self.class.class_eval <<code

  def #{selector}
    subscriptions.where(publication_type: "#{$1}", subscriber_id: id).collect{|s| s.publication}
  end

code
      end
      send selector
    else
      super
    end
  end
end

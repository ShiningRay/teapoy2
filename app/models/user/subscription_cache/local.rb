# coding: utf-8
module User::SubscriptionCache::Local
  def has_subscribed?(publication)
    s = local_sub_cache(publication.class.name)

    s.include?(publication.id) ? s[publication.id] : (s[publication.id] = super)
  end

  # def publications(type)
  #   local_pub_cache(type.to_s)
  #   @__pub[type.to_s] ||= super
  # end

  def preload_subscribed(publications)
    return if publications.size == 0

    name = publications[0].class.name
    store = local_sub_cache(name)
    ids = publications.collect do |p|
      i = p.id
      store[i] = false
      i
    end
    subscriptions.where(:publication_type => name, :publication_id => ids).each do |s|
      store[s.publication_id] = true
    end
    store
    logger.debug(@__subscribed)
  end

  def subscribe(publication)
    local_sub_cache(publication.class.name)[publication.id] = publication  if r = super
    r
  end

  def unsubscribe(publication)
    local_sub_cache(publication.class.name).delete(publication.id)
    super
  end

  def local_sub_cache(type)
    @__subscribed ||= {}
    @__subscribed[type] ||= {}
  end
  private :local_sub_cache

  def local_pub_cache(type)
    @__pub ||= {}
    @__pub[type] ||= []
  end
  private :local_pub_cache
end

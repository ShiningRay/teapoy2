# coding: utf-8
# store rating information in remote cache store like memcache
module User::RatingCache::Remote
  def has_rated?(post)
    Rails.cache.fetch(rating_cache_key(post)) do
      super
    end
  end

  # utilize batch fetching to obtain an hash of cached ratings
  def ratings_for(*post)
    key2post = {}  # the mapping from key name in memcache to post record
    result = {}  # the result to be returned
    pid2post = {} # the mapping from post id to post

    # establish the mappings
    post.each do |i|
      pid2post[i.id]= key2post[rating_cache_key(i)] = post
    end
    keys = key2post.keys # all keys for memcache

    # fetch cached results
    cached_results = Rails.cache.read_multi(*keys)

    # find out the keys that not exists in memcache
    noncached_keys = keys - cached_results.keys
    # find out the posts that not has be cached rating status in memcache
    noncached_post = key2post.values_at(*noncached_keys)

    # pull cached results into final results
    cached_results.each do |k, v|
      result[key2post[k].id] = v
    end

    # let super method handle missing posts rating status (fetch from db)
    noncached_result = super(*noncached_post)

    # write the results fetched from db back to memcache
    noncached_result.each do |pid, s|
      Rails.cache.write(rating_cache_key(pid2post[pid]), r)
    end

    result.merge(noncached_result)
  end

  private
  def rating_cache_key(p)
    [self.login, :rate, p]
  end
end

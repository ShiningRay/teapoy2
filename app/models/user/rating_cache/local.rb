# coding: utf-8
# cache the rating information by user locally in a instance variable hash
# named "rating_cache".
module User::RatingCache::Local
  # fill cache when missing
  def has_rated?(post)
    rating_cache[post.id] ||= super
  end


  def ratings_for(*post)
    pid2post = {}
    post.each{|p|pid2post[p.id]=post}
    pid = pid2post.keys

    # first find out locally cached results
    cached_result = {}
    pid.each do |i|
      cached_result[i] = rating_cache[i] if rating_cache[i]
    end

    # use super method for locally missed results
    noncached_pid = pid - cached_result.keys
    noncached_result = super(pid2post.values_at(*noncached_pid))

    # store remote fetched result and store locally
    rating_cache.merge! noncached_result

    # merge results and return
    cached_result.merge(noncached_result)
  end

  def rating_cache
    @rating_cache ||= {}
  end
  private :rating_cache
end

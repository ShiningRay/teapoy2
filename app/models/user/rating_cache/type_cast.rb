# coding: utf-8
# convert params for future use
module User::RatingCache::TypeCast
  def has_rated?(post)
    post = Post.wrap(post) unless post.is_a?(Post)
    super
  end


  def ratings_for(*post)
    post.flatten!
    post.compact!
    post.collect!{|p| Post.wrap(p)}
    post.compact!
    super
  end
end

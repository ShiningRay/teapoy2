# coding: utf-8
module Score
  # Public
  # the initial score when create inbox record
  def initial(post, receiver)
    if post.is_a?(Repost)
      15
    else
      30
    end
  end
  # Public
  # then deliver the post again to receiver
  # how to change the score
  def again(post, receiver)
    if post.is_a?(Repost)
      5
    else
      10
    end
  end

  def up(post, caster)
    5
  end

  def down(post, caster)
    -5
  end

  def change(post, rating)
    if rating.score > 0
      up(post, rating.user)
    else
      down(post, rating.user)
    end
  end

  module_function :initial, :up, :down, :change, :again
end

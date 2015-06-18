module RatingsHelper

  # TODO: optimize out the regexp match
  def rated? post
    if logged_in?
      current_user.has_rated? post
    end
  end

  def rating_status(post, liked=nil, disliked=nil, unvoted=nil, disabled=nil, args={})
    args = args.with_indifferent_access
    liked ||= args[:liked] || args[:pos]
    disliked ||= args[:disliked] || args[:neg]
    unvoted ||= args[:unvoted]
    disabled ||= args[:disabled]
    current_user.own?(post) ? disabled : Rating.status_for(current_user.has_rated?(post), liked, disliked, unvoted)
  end

  # X axis: the action user want to take
  # Y axis: the action user has taken
  RATING_MATRIX=[
    ['disliked', 'cannot_dislike', 'like'],   #
    ['dislike',   0,               'like'],
    ['dislike',  'cannot_like',    'liked']]
  # generate correct rating link
  # the rating link has 3 states, has rated, can be rated(not yet rated), cannot be rated(e.g. user's own post)
  # together with 3 score -1(down), 0(not rated), 1(up)
  # use the matrix above to choose correct template to render
  def rating_link(post, action)
    return if post.destroyed?
    #Rails.cache.fetch(cache_key_for_current_user([:ratinglink, $revision, theme_name, request.format.to_sym, action, post])) do
      action_score = Rating.score_for(action)
      opts = {locals: {user: current_user, post: post}}
      rated_score = logged_in? ? current_user.has_rated?(post) : 0

      if logged_in? && current_user.id == post[:user_id]
        rated_score = action_score
        action_score = 0
      end

      opts[:score] = rated_score
      partial = RATING_MATRIX[rated_score.to_i+1][action_score+1] # +1 to adjust for matrix
      Rails.logger.debug("Post #{post.id} using partial #{partial}")
      if partial != 0
        opts[:partial] = "ratings/#{partial}"
        render( opts)
      end
    #end
  end

  def vote_icon(post, voted_prefix, score_prefix, path, extname)
    path = send "#{direction}_post_path", post
    if logged_in?
      if post[:user_id] == current_user.id
        link_to image_tag(disabled_icon), '#'
      else
        r = current_user.has_rated?(post)
        s = r > 0 ? :up : :dn
        if direction == s
          link_to image_tag(voted_icon), path
        else
          link_to image_tag(unvoted_icon), path
        end
      end
    else
      link_to image_tag(unvoted_icon), path
    end
  end
end

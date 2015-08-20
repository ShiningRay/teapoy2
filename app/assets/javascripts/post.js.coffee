$ ->
  p = {}
  if current_user?
    p.user_id = current_user.id
    $(".user-#{current_user.login}").addClass('mine')

  p.ids = []
  $('.post').each  ->
    p.ids.push($(this).data('id'))

  if p.ids.length > 0
    $.get('/posts/scores.json', p).done (data) ->
      $.each data, (i, post) ->
        $("#post_#{i} .score").text(post.score)
        if post.rated?
          switch post.rated
            when 1 then $("#post_#{i} .midcol").removeClass('unvoted').addClass('likes voted')
            when -1 then $("#post_#{i} .midcol").removeClass('unvoted').addClass('dislikes voted')

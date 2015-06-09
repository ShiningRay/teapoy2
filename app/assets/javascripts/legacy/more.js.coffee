$ ->
  $('.article').on 'click', 'a.more', ->
    article = sr.article(this)
    post = sr.post(this)
    id = post.attr('id')
    target = $(this).data('target')
    article.load "#{$(this).attr('href')} \##{id}"
    false

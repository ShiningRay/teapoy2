$ ->
  $('.topic').on 'click', 'a.more', ->
    topic = sr.topic(this)
    post = sr.post(this)
    id = post.attr('id')
    target = $(this).data('target')
    topic.load "#{$(this).attr('href')} \##{id}"
    false

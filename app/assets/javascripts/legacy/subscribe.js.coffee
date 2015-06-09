
$ ->
  $('.article').on 'click', '.subscribe,.unsubscribe', ->
    e = $(this)
    p = e.parent()
    p.load("#{e.attr('href')}", (text) ->
      p.html($("<div>").append(text).find(".#{p.attr('class')}").html())
    )
    return false


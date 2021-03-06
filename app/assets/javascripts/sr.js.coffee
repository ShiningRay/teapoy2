window.B = window.sr =
  post: (o) ->
    $(o).parents ".post:first"
  topic: (o) ->
    $(o).parents ".topic:first"
  object_id: (o) ->
    n = $(o).attr("id")
    n?.split /_/

  id: (o) ->
    a = sr.object_id(o)
    a?[a.length - 1]
  isLoggedIn: ->
    !!window.current_user
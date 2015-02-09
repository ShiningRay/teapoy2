#= require 'jquery/hoverIntent'
$ ->
  show = ->
    $t = $(this)
    e = $t.next()
    w = $t.width()
    h = $t.height()
    #o = $t.offset()
    o = $t.position()
    #console.debug(o)
    e.css(o).show().width(w).height(h).animate({width: 200, height: e.children('.detail').height()+26})
    #console.debug(e.offset());
  hide = ->
    #console.log($(this))
    e = $(this).prev()
    w = e.width()
    h = e.height()
    $(this).animate({width:w, height:h}, -> $(this).hide())

  $('.channel-name').hoverIntent(
    over: show
    timeout: 400
    out: ((e)->e)
    interval: 400
  )
  $('.groups-index .groups-list .group').mouseleave(hide)
  $('.my-index .groups-list .group').mouseleave(hide)
  $('.my-groups .groups-list .group').mouseleave(hide)

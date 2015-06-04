#= require waypoints/jquery.waypoints.js
#= require waypoints/shortcuts/inview.js


$(document).bind 'pageinit', ->
  $('a[rel=next]').click ->
    if $(this).hasClass('loading')
      return false
    $(this).addClass('loading')
    $.mobile.loading( "show" )
    $.get this.href, (data) =>
      $(data).find(".article-list").appendTo(".article-list")
      $(".article-list").enhanceWithin()
      this.href = $(data).find('a[rel=next]').attr('href')
      $(this).removeClass('loading')
      $.mobile.loading( "hide" )
      Waypoint.refreshAll()
    return false

  # inview = new Waypoint.Inview
  #   element: $('a[rel=next]')[0]
  #   enter: (direction) ->
  #     console.log('enter')
  #     $('a[rel=next]').click() if direction is 'down'

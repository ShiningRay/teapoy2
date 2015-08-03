# loading more
$(document).bind 'pageshow', ->
  $('a[rel=next]').click ->
    if $(this).hasClass('loading')
      return false
    $(this).addClass('loading')
    $.mobile.loading( "show" )
    $.get this.href, (data) =>
      $(data).find(".topic-list").enhanceWithin().timeago().appendTo(".topic-list")

      this.href = $(data).find('a[rel=next]').attr('href')
      $(this).removeClass('loading')
      $.mobile.loading( "hide" )
    return false

# infinitive scrolling
$(document).bind 'scrollstop', ->
  if $(window).scrollTop() + $(window).height() >= $(document).height() - 100
    $('.ui-page-active').find('a[rel=next]').click()


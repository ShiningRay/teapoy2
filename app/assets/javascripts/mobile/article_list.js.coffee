# loading more
$(document).bind 'pageshow', ->
  $('a[rel=next]').click ->
    if $(this).hasClass('loading')
      return false
    $(this).addClass('loading')
    $.mobile.loading( "show" )
    $.get this.href, (data) =>
      $(data).find(".topic-list").enhanceWithin().appendTo(".topic-list")

      this.href = $(data).find('a[rel=next]').attr('href')
      $(this).removeClass('loading')
      $.mobile.loading( "hide" )
    return false

# infinitive scrolling
$(document).bind 'scrollstop', ->
  if $(window).scrollTop() + $(window).height() >= $(document).height() - 100
    $('a[rel=next]').click()

(($) ->
  $.toast = (content, duration=3000) ->
    $el = $("<div class=\"ui-toast\">#{content}</div>").appendTo('body')
    bw = $('body').width()
    bh = $('body').height()
    top = (bh*3/4) - $el.height()/2
    left = bw/2 - $el.width()/2
    $el.css('top', top+'px')
    $el.css('left', left+'px')
    $el.fadeIn().delay(duration).fadeOut ->
      $el.remove()
      $el = null
)(jQuery)

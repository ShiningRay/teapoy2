#= require sr
#= require 'plugins/hover'

$ ->
  removeExistedItem = (items) ->
    newItems = []
    items.each ->
      id = $(this).attr("id")
      newItems.push this  if id and $("#" + id).size() is 0

    $ newItems
  loadMoreItem = ->
    self=$(this)
    return false if self.hasClass('loading')
    self.addClass('loading')
    last = $(".articles-list .article:last time")
    $.get "/my/latest",
      before: Date.parse(last.attr('datetime')) / 1000
    , (data) ->
      self.removeClass('loading')
      try
        data = $(data)
      catch error
        return
      data = removeExistedItem(data).appendTo(".articles-list")
      $('.external_video .flash_link',data).each ->
        $(this).append("<img src='/images/videoplay.gif' alt='' class='overlay'/>")
      rest = parseInt($(".more-item .value").text()) - data.size()
      if rest is 0
        $(".more-item").hide()
      else
        $(".more-item .value").text rest  
        $(".articles-list").trigger('change')
    
    false
  $('.my-latest .more-item').click loadMoreItem
  $(".markread a").live "click", -> 
    id = sr.article($(this)).attr('id').split("_")[1]
    $.get "/articles/#{id}/dismiss"
    sr.article($(this)).remove();
    #if $(".articles-list").find("article").size < 3
      #loadMoreItem
    return false
$ ->
  return unless $('body').hasClass('my-inbox');
  removeExistedItem = ->
    $(".article").each ->
      i = sr.id(this)
      idx = undefined
      items.splice idx, 1  if i and (idx = items.indexOf(parseInt(i))) > -1
      $(".more-item .value").text items.length  

  $(".my-inbox .more-item .value").text items.length
  loadMoreItem = ->
    self = $(this)
    return if self.hasClass('loading')
    removeExistedItem()
    ids = items.slice(0, 30)
    if ids.length > 0
      self.addClass('loading')
      $.get "/my/inbox",
        ids: ids
      , (data) ->
        $(data).appendTo(".articles-list")
        removeExistedItem()
        $(".articles-list").trigger('change')
        self.removeClass('loading')
    else
      $(".more-item").hide()
    false
  $ removeExistedItem
  $(".my-inbox .more-item").click loadMoreItem
$ ->
  return unless $("body").hasClass('my-inbox') or $("body").hasClass('my-latest')
  $current = undefined
  lastpos = 0
  nowpos = 0
  activeCurrentArticle = (el) ->
    unless el.size() == 0 or el.is($current)
      $current.removeClass('current')
      if $current.hasClass('unread')
        id = sr.id($current)
        $last = $current
        $.post "/articles/#{id}/mark", ->
          $last.removeClass('unread').addClass('read')
      $current = el.addClass('current') 

  $(window).scroll ->
    #console.log($current)
    #console.log(height)
    #console.log(lastpos)

    unless $current?
      $current = $('.articles-list .article:first')
      $current.addClass('current')
      return 
    nowpos = $(window).scrollTop()

    if nowpos > lastpos  # go down
      offset = $current.offset()
      height = $current.height()    
      if (offset.top + height/2) < nowpos
        activeCurrentArticle $current.next() 
    else if nowpos < lastpos  # go up
      prev = $current.prev()
      if prev.size() > 0
        offset = prev.offset()
        if offset.top > nowpos
          activeCurrentArticle prev

    lastpos = nowpos
  $('.articles-list').on 'click', '.article', -> 
    activeCurrentArticle $(this)

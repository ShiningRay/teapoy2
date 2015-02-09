#= require 'jquery/poshytip'
#= require 'vendor/soundmanager2-nodebug-jsmin'
#= require "jquery/waypoints"
#= require 'jquery/ba-throttle-debounce'
#= require 'plugins/hover'
#= require 'views/new_article'
#= require 'views/article'
#= require 'views/notifications'
#= require 'views/comments'
#= require 'vendor/amplify.min'
#= require 'vendor/json2'
#= require 'jquery/ba-throttle-debounce'


clear_notifications_area = ->
  if $(".notification-box  .notification").length is 0
    $(".notification-box").hide()
  else
    $(".notification-box").show()

(($) ->
  $.fn.extend dismiss: (options) ->
    this.each ->
      self = $(this)
      return unless self.hasClass('notification')
      self.fadeOut ->
        self.remove()
      id = self.attr('id').split("_")[1]
      $.getJSON("/notifications/#{id}/dismiss")
      #clear_notifications_area()
) jQuery


$ ->
  return unless sr.isLoggedIn()
  bling = null

  soundManager.onready(->
    bling = soundManager.createSound(
      id: 'bling'
      url: '/au/bling.mp3'
      autoLoad: true
      autoPlay: false
    )
  )
  playBling = $.debounce 10000, true, ->
    if bling
      bling.play()
    else
      soundManager.onready -> bling.play()
  fetchNotificationsCount = ->
    $.getJSON('/session.json?'+(new Date().valueOf()), (data) ->
      #notification
      unc = $('.unread_notifications_count')
      val = $('.value', unc)

      original_count = parseInt(val.text())
      if data.unread_notifications_count > 0
        val.text(data.unread_notifications_count)
      #console.debug(data)
      if data.unread_notifications_count == 0
        unc.addClass('empty')
      else
        unc.removeClass('empty')
        if original_count < data.unread_notifications_count
          bling.play() if bling
      #messages
      unc = $('.messages')
      val = unc.find('.value')
      original_count = parseInt(val.text())
      #return if isNaN(original_count)
      val.text(data.unread_messages_count)
      #console.debug(data)
      if data.unread_messages_count == 0
        val.text('')
      else
        if original_count < data.unread_messages_count
          bling.play() if bling
    )
  #showNotifications = ->
  $('.unread_notifications_count').bind('refresh', fetchNotificationsCount)
  $('.unread_notifications_count a').poshytip
    className: 'tip-twitter notifications-tip'
    alignTo: 'target'
    alignX: 'center'
    allowTipHover: yes
    content: (updateCallback) ->
      $.get '/notifications', (data) ->
        updateCallback(data)

  # setInterval(fetchNotificationsCount, 30000)

  $.waypoints.settings.scrollThrottle = 30

  load_notifications = ->
    $.get "/notifications", (data) ->
      $(".notification-box").html data #$.templates.render('notifications', data)
      #clear_notifications_area()

      $(".notification-box .notification").each ->
        id = $(this).attr('id')
        unless amplify.store(id) is '1'
          playBling()
          amplify.store(id, '1')
      setTimeout load_notifications, 60000

  # load_notifications()

  if $('html').hasClass('ie6')
    $(window).scroll $.debounce(200, ->
      sTop = $(this).scrollTop()
      nbox = $(".notification-box").css('top', sTop)
      if sTop > 110
        nbox.css('position', 'absolute')
        #nbox.fadeIn()
      else
        nbox.css('position', 'static')
      )
  else
    $(".notification-box").waypoint (event, direction) ->
      offset = $(this).offset()
      $(this).toggleClass 'fixed', direction is "down"
      event.stopPropagation()

  highlight = (a, fun) ->
    $.scrollTo a, 500,
      offset: -100
      onAfter: ->
        fun a if fun
        a.effect "highlight", 3000
  load_comments = (group_alias,article_id,highlight_comment_id) ->
    article = $("article#article_#{article_id}")
    $.getJSON "/#{group_alias}/#{article_id}/comments" , (data, status, xhr) ->
      if  xhr.status is 200
        if article.find(".comments_article").length > 0
          article.find(".comments_article").remove()
        $(window.templates.render('comments', data)).appendTo(article)
        if article.find("ul.comments li").length > 0
          A.text article.find("ul.comments li").length +"条评论"
        else
          A.text("暂无评论")
        highlight $("li#post_#{highlight_comment_id}")

  $(".notification-box").on "click", 'li', ->
    self = $(this)
    article = $("#article_" + self.data("article_id"))
    if article.size() is 0
      $.getJSON self.data("article_url"), (data) ->
        if($('body').hasClass('my-inbox') || $('body').hasClass('my-latest'))
          highlight $(window.templates.render('new_article',data)).prependTo(".articles-list"), (article) ->
            $('a.comments', article).click() if self.data('scope') is 'reply'
        else
          highlight $(window.templates.render('article',data)).prependTo(".articles-list")
        self.dismiss()
    else
      highlight article,( ->
        if self.data('scope') is 'reply' and $('.comment', article).size() < parseInt(self.data('comments_count'))
          $('.comments_article', article).remove()
          $('a.comments', article).click()
        self.dismiss())
    #load_comments self.data("group_alias"),self.data("article_id"),self.data("comment_id")
    return false
  if $('html').hasClass('ie6')
    autoHoverClass('.notification', '.notification-box')
$("#clear_all_notifications").on "click", 'a', ->
  $(this).parent().next().find("li").each ->
    $(this).dismiss()
  false

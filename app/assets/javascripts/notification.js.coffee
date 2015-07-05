#= require 'qtip2'
#= require 'vendor/soundmanager2-nodebug-jsmin'
#= require 'jquery/ba-throttle-debounce'

$ ->
  return unless sr.isLoggedIn() # 未登录的用户不用刷新通知信息
  bling = null
  # 加载提示音的文件
  soundManager.onready(->
    bling = soundManager.createSound(
      id: 'bling'
      url: '/au/bling.mp3'
      autoLoad: true
      autoPlay: false
    )
  )
  # 播放提示音
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
  $('.unread_notifications_count a').qtip
    style:
      classes: 'qtip-tipsy'
    position:
      at: 'bottom center'
      my: 'top center'
    hide:
      fixed: true
    content: (event, api) ->
      $.get '/notifications', (data) ->
        api.set('content.text', data)
      "Loading..."
  # setInterval(fetchNotificationsCount, 30000)

  # $.waypoints.settings.scrollThrottle = 30

  load_notifications = ->
    $.get "/notifications", (data) ->
      $(".notification-box").html data
      #$.templates.render('notifications', data)
      #clear_notifications_area()

      $(".notification-box .notification").each ->
        id = $(this).attr('id')
        unless amplify.store(id) is '1'
          playBling()
          amplify.store(id, '1')
      setTimeout load_notifications, 60000

  # load_notifications()

$("#clear_all_notifications").on "click", 'a', ->
  $(this).parent().next().find("li").each ->
    $(this).dismiss()
  false

class window.Puller
  constructor: (@url, @period=5000) ->
    @locking = false
    @running = false
    @timer = null
    @unread = 0
    @originalTitle = document.title

  start: ->
    @running = true
    @timer = setTimeout(( => @pull()), @period)
  stop: ->
    @running = false
    clearTimeout @timer
  # updateTitle: (nodes) ->
  #   if nodes
  #     @unread += nodes.length
  #   if window.focused
  #     @unread = 0
  #   if @unread == 0
  #     document.title = @originalTitle
  #   else
  #     document.title = "(#{@unread}) #{@originalTitle}"
  # showNotification: (nodes) ->
  #   notify.createNotification("收到#{nodes.length}条消息", {
  #     icon: '/assets/icon.ico'
  #   })
  pull: (toAlert = true) ->
    return if @locking
    @locking = true
    if @timer
      clearTimeout(@timer)
    $.get(@url, {
      after: $('.message').last().data('id')
    }).done (data) ->
      unless data.match(/^\s*$/)
        $('.msg_box').append(data)
        $(window).scrollTo('100%')
      # window.alertSound.play() if window.alertSound and toAlert
      # $('#comments').timeago('refresh')
    .always =>
      @locking = false
      if @running
        @start()

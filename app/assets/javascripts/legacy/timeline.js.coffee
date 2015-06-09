x#= require waypoints/jquery.waypoints.js
#= require 'jquery/ba-throttle-debounce'
#= require 'views/new_article'
#= require 'views/article'
#= require 'views/notifications'
#= require 'views/comments'
#= require 'vendor/amplify.min'
#= require 'vendor/json2'


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

) jQuery


$ ->
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

# @charset "utf-8";
#= require 'jquery/scrollTo'
#= require 'jquery/autoresize'
#= require "jquery/ba-throttle-debounce"
# old comment handler
#console.debug(xhr)
#.hide().slideDown(500);
#console.debug(xhr)
#      alignTo: 'target',
window.replyComment = (comment_id, article_id, reply_to_floor) ->
  article = $("#comments_article_" + article_id)
  editorTextPosition = -1
  commentArea = $("#post_content")
  editorPositionFunc = ->
    editorTextPosition = $(this).textPosition()

  commentArea.mouseup(editorPositionFunc).keyup editorPositionFunc
  editorTextPosition = commentArea.textPosition()  if editorTextPosition is -1
  floor = $("#post_parent_id", article).val()
  if parseInt(floor) > 0
    content = "  @#{$.trim($("#post_#{comment_id} .nickname").text())} "
    pos = commentArea.val().length
    commentArea.textPosition pos, content
    commentArea.focus()
  else
    $("#post_parent_id", article).val reply_to_floor
    nickname = $.trim($("#post_#{comment_id} .nickname").text())
    nv = "回复#{reply_to_floor}L #{nickname}: "
    orig_text = commentArea.val()
    commentArea.val(nv + orig_text).focus().setCursorPosition nv.length

#查看某人对帖子的评论
window.show_comment_of = (me, user_login) ->
  target = "user-" + user_login
  to_show = []
  to_hide = []

  me.parents(".comments_article:first").find("ul.comments li.comment").each ->
    if @className.indexOf(target) >= 0
      to_show.push this
    else
      to_hide.push this

  $(to_show).slideDown 500
  $(to_hide).slideUp 500


window.show_all = (article_id) ->
  a = $("#comments_article_" + article_id).find("ul.comments li")
  if a.size() < 50
    a.slideDown 500
  else
    a.show()
$ ->
  return  if $("body").hasClass("my-inbox") or $("body").hasClass("my-latest")
  $("form#new_post").autoResize
    animate: true
    animateDuration: 600
    extraSpace: 0

  $(".in-reply-to").click(->
    target = $(this).attr("href").replace("#", "")
    fl = $("." + target)
    fl.slideDown 1000  if fl.is(":hidden")
    $.scrollTo fl, 1000,
      offset:
        top: -100

      axis: "y"

    false
  ).poshytip
    className: "tip-green"
    offsetX: -7
    offsetY: 16
    liveEvents: true
    content: ->
      target = $(this).attr("href").replace("#", "")
      $("." + target, $(this).parents("ul.comments:first")).html()

  $(".comment .reply").poshytip
    liveEvents: true
    className: "tip-green"
    offsetX: -7
    offsetY: 16
    content: ->
      result = ""
      commented = $(this).parents("ul.comments:first")
      .find(".comment[data-parent_id=#{$(this).data('floor')}]")
      if commented.length
        commented.each ->
          result += $(this).html()

      else
        result = "暂时没有针对这条评论的回复"
      result

  $("#content").on("click", "a.show_readed", ->
    myself = $(this)
    return false  if myself.hasClass("loading")
    read = myself.nextAll("li.read")
    if read.size() < 50
      read.slideDown 500
    else
      read.css "display", "block"
    myself.removeClass("show_readed").addClass "hide_readed"
    false
  ).on "click", "a.hide_readed", ->
    read = $(this).nextAll("li.read")
    if read.size() < 50
      read.slideUp 500
    else
      read.css "display", "none"
    $(this).removeClass("hide_readed").addClass "show_readed"
    false

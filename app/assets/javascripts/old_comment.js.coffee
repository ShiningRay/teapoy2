# @charset "utf-8";
#= require 'jquery/scrollTo'
#= require 'jquery/autoresize'
#= require "throttle-debounce"
#= require qtip2
# old comment handler
#console.debug(xhr)
#.hide().slideDown(500);
#console.debug(xhr)
#      alignTo: 'target',
window.replyComment = (comment_id, topic_id, reply_to_floor) ->
  floor = $("#post_parent_id").val()
  nickname = $.trim($("#post_#{comment_id} .nickname").text())
  replyTextArea = $("#post_content").data('editor')
  orig_text = replyTextArea.getValue()

  if parseInt(floor) > 0
    content = "@#{nickname} "
  else
    $("#post_parent_id").val reply_to_floor
    content = "回复#{reply_to_floor}L #{nickname}: "

  replyTextArea.setValue(content + orig_text)
  replyTextArea.focus()
#查看某人对帖子的评论
window.show_comment_of = (me, user_login) ->
  target = "user-" + user_login
  to_show = []
  to_hide = []

  me.parents(".comments_topic:first").find("ul.comments li.comment").each ->
    if @className.indexOf(target) >= 0
      to_show.push this
    else
      to_hide.push this

  $(to_show).slideDown 500
  $(to_hide).slideUp 500


window.show_all = (topic_id) ->
  a = $("#comments_topic_" + topic_id).find("ul.comments li")
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
  ).qtip
    content: (event, api) ->
      e = $(event.target)
      target = e.attr("href").replace("#", "")
      $("." + target, e.parents("ul.comments:first")).html()

  $(".comment .reply").qtip
    content: (event, api) ->
      result = ""
      e = $(event.target)
      commented = e.parents("ul.comments:first")
      .find(".comment[data-parent_id=#{e.data('floor')}]")
      if commented.length
        commented.each ->
          result += e.html()
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

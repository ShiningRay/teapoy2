#= require jquery
#= require ajaxlogin

$ ->

  $('.need-login').click ->
    sr.showLogin();return false;
  $("#recommend_groups_form .group").click ->
    if $("input[type=checkbox]", this).attr("checked") is "checked"
      $("input[type=checkbox]", this).removeAttr "checked"
    else
      $("input[type=checkbox]", this).attr "checked", "checked"
    $(this).toggleClass "selected"

  $("#recommend_groups_form input[type=checkbox]").change ->
    $("#group_" + $(this).val()).toggleClass "selected"
  #$('#recommend_groups_form > ul')

  $("#user_captcha_input img").click ->
    $(this).load("/update_captcha",
      authenticity_token:$("meta[name='csrf-token']").attr("content")
      , (text)->
        $(this).html(text)
    )
    return false
  verify = (myself) ->
    if myself.size() > 0 && myself.val().length > 0
      $.ajax
        type: "POST"
        url: "/register/check"
        data:
          check_area: myself.val()
          check_name: myself.attr("check_area")
          authenticity_token: $($("input[name='authenticity_token']").get(0)).val()
        success: (data) ->
          $("<p class='inline-errors'>" + data.error_message + "</p>").insertAfter myself  if data.error_message
        dataType: "json"
  $(".need_verify").change ->
    myself = $(this)
    myself.next(".inline-errors").remove()
    verify(myself)

  $(document).ready ->
    verify($("#user_name"))
    verify($("#login_input"))
  form = $('#recommend_groups_form')
  if $("html").hasClass('ie6') and form.size() > 0
    offset = form.offset()
    height = $(window).height() - offset.top;
    form.css('height', height)
    list = form.find('.recommended_groups')
    bottom = parseInt(list.css('bottom'))
    list.css('bottom', 'auto')
    list.height(height - bottom)
    submit = form.find('.submit_block')
    submit.css
      top: offset.top + height - 20
      bottom: 'auto'



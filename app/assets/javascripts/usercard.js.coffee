#= require "jquery/outerhtml"
#= require 'icanhaz'
#= require qtip2
usercard_tmpl = """
<div class="usercard hovercard" id="usercard-{{login}}">
  <div class="icon">
    <a class="icon" href="{{user_url}}">
      <img src="{{avatar_url}}" alt="{{name}}">
    </a>
  </div>
  <div class="detail">
    <a class="name" href="{{user_url}}">
      {{name}}
    </a>
    <a class="login" href="{{user_url}}">
      @{{login}}
    </a>
    <div class="join">
      <a class="follow" href="{{follow_or_unfollow_url}}">
        {{follow_or_unfollow_text}}
      </a>
      |
      <a class="send-message" href="{{message_url}}">
        小纸条
      </a>
    </div>
  </div>
</div>
"""

groupcard_tmpl = """
<div class="groupcard hovercard" id="groupcard-{{alias}}">
  <div class="icon">
    <a class="icon" href="{{group_url}}">
      <img src="{{icon.icon.small.url}}" alt="{{name}}">
    </a>
  </div>
  <div class="detail">
    <a class="name" href="{{group_url}}">
      {{name}}
    </a>
    <div class="description">
      {{description}}
    </div>
    <div class="join">
      <a class="join_group" href="{{join_or_quit_group_url}}">
        {{join_or_quit_text}}
      </a>
      |
      <a href="{{new_topic_path}}" target="_blank">
        发表
      </a>
    </div>
  </div>
</div>
"""

ich.addTemplate('usercard', usercard_tmpl)
ich.addTemplate('groupcard', groupcard_tmpl)
usercards_container = null
groupcards_container = null
loadUserInfo = (login, cb) ->
  card  = $("#usercard-#{login}")
    # body...
  return setTimeout((->cb(card.outerHTML())), 50) if card.size() > 0

  $.getJSON "/users/#{login}.json", (data) ->
    output = ich.usercard(data)
    usercards_container ?= \
      $('<div id="usercards-container" style="display:none">').appendTo('body')

    $('#usercards-container').append(output)
    cb(output)

loadGroupInfo = (gid, cb) ->
  card  = $("#groupcard-#{alias}")
  return setTimeout((->cb(card.outerHTML())), 50) if card.size() > 0

  $.getJSON "/groups/#{alias}.json", (data) ->
    output = ich.groupcard(data)
    $('#groupcards-container').append(output)
    groupcards_container ?= \
      $('<div id="groupcards-container" style="display:none">').appendTo('body')

    cb(output)
qtipOptions =
  overwrite: false
  style:
    classes: 'qtip-tipsy'
  position:
    my: 'bottom center'
    at: 'top center'
  hide:
    fixed: true


opt1 = $.extend
  content: (event, api) ->
    e = $(event.target)
    login = e.data('login')
    loadUserInfo login, (content) ->
      api.set('content.text', content)
    'Loading...'
  , qtipOptions
  
$(document).on 'mouseenter', '.user[data-login]', (e)->
  _opt1 = $.extend
    show:
      event: e.type
      ready: true
    , opt1
  $(this).qtip _opt1, e
opt2 = $.extend
  content: (event, api) ->
    e = $(event.target)
    login = e.data('alias')
    loadGroupInfo login, (content) ->
      api.set('content.text', content)
    'Loading...'
  , qtipOptions

$(document).on 'mouseenter', '.group[data-alias]', (e)->
  _opt2 = $.extend
    show:
      event: e.type
      ready: true
    , opt2
  $(this).qtip _opt2, e

#= require "jquery/poshytip"
#= require "jquery/outerhtml"
#= require 'icanhaz'

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

$ ->
  ich.addTemplate('usercard', usercard_tmpl)
  ich.addTemplate('groupcard', groupcard_tmpl)
  usercards_container = \
    $('<div id="usercards-container" style="display:none">').appendTo('body')
  $('.user[data-login]').poshytip
    className: 'tip-twitter'
    bgImageFrameSize: 11
    alignTo: 'target'
    alignX: 'center'
    fade: false
    slide: false
    liveEvents: true
    content: (update) ->
      e     = $(this)
      login = e.data('login')
      card  = $("#usercard-#{login}")

      return card.outerHTML() if card.size() > 0

      $.getJSON "/users/#{login}.json", (data) ->
        output = ich.usercard(data)
        $('#usercards-container').append(output)
        update(output)
      'Loading...'
$ ->
  groupcards_container = \
    $('<div id="groupcards-container" style="display:none">').appendTo('body')

  $('.group[data-alias]').poshytip
    className: 'tip-twitter'
    bgImageFrameSize: 11
    alignTo: 'target'
    alignX: 'center'
    fade: false
    slide: false
    content: (update) ->
      e     = $(this)
      alias = e.data('alias')
      card  = $("#groupcard-#{alias}")

      if card.size() > 0
        return card.outerHTML()

      $.getJSON "/groups/#{alias}.json", (data) ->
        output = ich.groupcard(data)
        $('#groupcards-container').append(output)
        update(output)
      'Loading...'

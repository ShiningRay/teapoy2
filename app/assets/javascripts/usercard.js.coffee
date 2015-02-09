#= require "jquery/poshytip"
#= require "views/usercard"
#= require "views/groupcard"
#= require 'views/article'

$ ->
  usercards_container = $('<div id="usercards-container" style="display:none">').appendTo('body')
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
        output = window.templates.render('usercard',data)
        $('#usercards-container').append(output)
        update(output)
      'Loading...'
$ ->
  groupcards_container = $('<div id="groupcards-container" style="display:none">').appendTo('body')

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
        output = window.templates.render('groupcard',data)
        $('#groupcards-container').append(output)
        update(output)
      'Loading...'

#= require 'jquery/jquery.placeholder'
#= require 'vendor/soundmanager2-nodebug-jsmin'

$ ->
  crop_background_image = ->
    bg = $('#background')
    wd = $(window)
    wr = w0 = parseInt(bg.attr('width'))
    hr = h0 = parseInt(bg.attr('height'))
    wv = wd.width()
    hv = wd.height()
    
    r0 = w0 / h0
    rv = wv / hv
    top = 0
    left = 0
    
    if rv == r0
      wr = wv
      hr = hv
    else if rv > r0
      wr = wv
      hr = wr / r0
      top = - (hr - hv) / 2
    else if rv <= r0
      hr = hv 
      wr = hr * r0
      left = - (wr - wv) / 2

    bg.css
      top: top
      left: left
      height: hr
      width: wr      

  $(window).resize(crop_background_image)
  crop_background_image()
  $('#background').fadeIn(800)
  $('input, textarea').placeholder()
  if not Modernizr.csstransitions
    $('#login-form a').mouseenter( ->
      $(this).stop().animate({'font-size': 24}, 700)
    ).mouseleave( ->
      $(this).stop().animate({'font-size': 14}, 500)
    )
    
  if $('body').hasClass('home-index') and soundManager?
    soundManager.onready(->
      bling = soundManager.createSound(
        id: 'welcome'
        url: '/au/welcome.mp3'
        autoLoad: true
        autoPlay: true
      )
    )

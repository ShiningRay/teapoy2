#= require jquery
#= require jquery_ujs
#= require jquery.remotipart
#= require jquery/scrollTo
#= require jquery.mobile
#= require photoswipe
#= require 'photoswipe/photoswipe-ui-default'

#= require_tree ./mobile

pictures = []

initPhotoSwipe = ->
  pictures = []
  i = 0
  $('a.picture').each ->
    a = $(this)
    a.data('index', i)
    i += 1
    img = a.find('img')
    pictures.push
      msrc: img.attr('src')
      w: a.data('width')
      h: a.data('height')
      src: a.attr('href')
      title: a.attr('title')

$(document).bind 'pageinit', ->
  disable = ->
    submitButton = $(this).find('input[type="submit"]')
    return if submitButton.prop('disabled')
    $.mobile.loading( "show" )
    # submitButton.data('original_text', submitButton.val());
    submitButton.prop('disabled', true)
    # submitButton.val(submitButton.data('disable_with'));
    submitButton.button('disable')
    # submitButton.button('refresh')
  enable = ->
    return unless submitButton.prop('disabled')
    submitButton = $(this).find('input[type="submit"]')
    # submitButton.val(submitButton.data('original_text'));
    submitButton.prop('disabled', false)
    submitButton.button('enable')
    $.mobile.loading( "hide" )
    # submitButton.button('refresh')

  disabled_with = (selector) ->
    $(document).on 'ajax:before', selector, disable
    .on 'ajax:complete', selector, enable
  disabled_with 'form#new_topic'
  disabled_with 'form#new_post'

  initPhotoSwipe()

  $('.ui-content').on 'vclick', 'a.picture', ->
    # gallery.init()
    pswpElement = document.querySelectorAll('.pswp')[0]
    options = {
      index: $(this).data('index')
      galleryUID: $(this).data('index')
    }
    gallery = new PhotoSwipe(
      pswpElement, PhotoSwipeUI_Default, pictures, options)
    gallery.init()
    return false
  $('.ui-content').on 'vclick', '.post .body', ->
    $(this).siblings('.reply').click()


# $(document).on 'pagecreate', ''

$ ->
  $('form, fieldset, fieldset li').focusin( ->
    $(this).addClass('focus')
  ).focusout( ->
    $(this).removeClass('focus')
  ).hover -> $(this).toggleClass('hover')
  $('input').focus(-> $(this).addClass('focus')).blur(-> $(this).removeClass('focus'))
#= require throttle-debounce
$ ->
  if $('#topic_content').size() > 0
    topic_content_editor = new Simditor
      textarea: $('#topic_content'),
      toolbar: [
        'title','bold','italic','underline','strikethrough','color','|'
        'ol','ul','blockquote','link','image','hr','|'
      ]
      pasteImage: true
      upload:
        url: '/upload'
    topic_content_editor.body.on 'dragover',
      $.debounce 250, true, ->
        topic_content_editor.focus()
    $('form#new_topic').submit ->
      $('#topic_content').val(toMarkdown($('#topic_content').val(), { gfm: true }))
    topic_content_editor.uploader.on 'uploadsuccess', (e, file, result) ->
      $('form#new_topic').append("<input type='hidden' class='attachment_ids' name='topic[attachment_ids][]' value='#{result.id}'>")


  if $('#post_content').size() > 0
    post_content_editor = new Simditor
      textarea: $('#post_content'),
      toolbar: [
        'bold','italic','underline','strikethrough','color','|'
        'ol','ul','blockquote','link','image','hr','|'
      ]
      pasteImage: true
      upload:
        url: '/upload'
    $('#post_content').data('editor', post_content_editor)
    $('form#new_post').submit ->
      $('#post_content').val(toMarkdown($('#post_content').val(), { gfm: true }))
    post_content_editor.on 'keypress', (event) ->
      if (event.ctrlKey or event.metaKey) and event.which is 13 or event.which is 10
        $('form#new_post').submit()
        return false
    post_content_editor.uploader.on 'uploadsuccess', (e, file, result) ->
      $('form#new_post').append("<input type='hidden' class='attachment_ids' name='post[attachment_ids][]' value='#{result.id}'>")


    post_content_editor.body.on 'dragover',
      $.debounce 250, true, ->
        post_content_editor.focus()
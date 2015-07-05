$ ->
  if $('#topic_content').size() > 0
    topic_content_editor = new Simditor
      textarea: $('#topic_content'),
      toolbar: [
        'title','bold','italic','underline','strikethrough','color','|'
        'ol','ul','blockquote','link','hr','|'
      ]
      # pasteImage: true
      # defaultImage: '<%= image_path "upload-loading.png" %>'
      # upload: {url: '/upload'}

    $('form#new_topic').submit ->
      $('#topic_content').val(toMarkdown($('#topic_content').val(), { gfm: true }))


  if $('#post_content').size() > 0
    post_content_editor = new Simditor
      textarea: $('#post_content'),
      toolbar: [
        'bold','italic','underline','strikethrough','color','|'
        'ol','ul','blockquote','link','hr','|'
      ]
    $('#post_content').data('editor', post_content_editor)
    $('form#new_post').submit ->
      $('#post_content').val(toMarkdown($('#post_content').val(), { gfm: true }))
    post_content_editor.on 'keypress', (event) ->

      if (event.ctrlKey or event.metaKey) and event.which is 13 or event.which is 10
        $('form#new_post').submit()
        return false
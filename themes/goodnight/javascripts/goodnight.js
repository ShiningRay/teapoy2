$(function(){
  $('a.vote').click(function(){
    var e = $(this), href = e.attr('href');
    $.getJSON(href).done(function(data){
      e.parent().find('.value').text(data.pos);
      e.remove();
    })
    return false;
  })
  $(document).on('submit', '.comment-form form', function () {
    if ($.trim($('textarea', this).val()) == '' && $('input[type=file]').val() == '') {
      return false;
    }
    var f = $(this), submit_button = f.find('input[type=submit]');
    submit_button.attr('disabled', "disabled").val('...');

    $.post(f.attr('action'), f.serialize()).done(function(data){
        f.clearForm();
        f.find('#post_parent_id').val("");
        f.parents('.article').find('ul.comment-list').append(data);
    }).always(function(){
        submit_button.removeAttr('disabled');
        submit_button.val('回复');
    })
    return false;
  });
  $('.article').on('click', 'a.comments', function(){
    var article = $(this).parents('.article'), comment_list = article.find('.comment-list');
    if(comment_list.size() > 0){
      comment_list.toggle();
    } else {
      $.get($(this).data('url')).done(function(data){
        article.append(data);
      })
    }
    return false;
  })
  $('#new_article').submit(function(){

  })
  $('a.add-title').click(function(){
    $('#article_title').show().focus();
    $(this).hide();
    return false;
  })
})

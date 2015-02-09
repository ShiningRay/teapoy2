$(function(){
  $('.vote').on('click', 'a', function(){
    var el=$(this);
    var post_id = el.parent().data('post_id');
    if(!sr.isLoggedIn()){
      return sr.showLogin();
    }
    $.get('/posts/'+post_id+'/'+(el.attr("class").indexOf('down') === -1 ? 'up' : 'dn'));
    $(this).addClass('vote-' + (el.attr("class").indexOf('down') === -1 ? 'up' : 'down')+'-on')
    var score = parseInt(el.parent().find('span').text());
    score +=(el.attr("class").indexOf('down') === -1 ? 1 : -1)
    el.parent().find('span').text(score);
    return false;
  })
})
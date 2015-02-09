new function($) {
  $.fn.setCursorPosition = function(pos) {
    if ($(this).get(0).setSelectionRange) {
      $(this).get(0).setSelectionRange(pos, pos);
    } else if ($(this).get(0).createTextRange) {
      var range = $(this).get(0).createTextRange();
      range.collapse(true);
      range.moveEnd('character', pos);
      range.moveStart('character', pos);
      range.select();
    }
  }
}(jQuery);


function showAnimation(containerId, actionValue){
    var obj = $('#'+containerId),
        pos = obj.offset(),
        ani = $('<div id="vote-ani" class="'+(actionValue > 0 ? "pos" : "neg")+'" style="font-size:10px;">'+(actionValue > 0 ? "+1" : "-1")+"</div>");
        ani.appendTo('body');
    ani.offset(pos).css('display', 'block').animate({'font-size': '64px', opacity: 0, left: "-=40"}, 250, 'linear', function(){ani.remove()});
}
var voteQueue=[];
function hidevotelink(id, p, n){
    var posscore,negscore;
    if(typeof p === 'undefined'){
        posscore = parseInt($('#pos-score-'+id).text());
    }else{
        posscore = p;
    }
    if(typeof n === 'undefined'){
        negscore = parseInt($('#neg-score-'+id).text());
    }else{
        negscore = n;
    }

//    console.debug(id);
    $('#score-'+id).html('<strong><span id="pos-score-'+id+'">' + posscore + '</span></strong>人支持<span class="space" style="zoom:1">|</span><strong><span id="neg-score-'+id+'">' + negscore + '</span></strong>囧');
}
function vote2(id, v, href){
    if(currentUser){
      var posscore = parseInt($('#pos-score-'+id).text()),
          negscore = parseInt($('#neg-score-'+id).text()),
          d = (v>0?'up':'dn');
      showAnimation(d+'-'+id, v);
      $.get(href);
      v > 0 ? posscore++ : negscore--;
      hidevotelink(id, posscore, negscore);
    }else{
      //voteQueue.push(v>0?id:-id);
      sr.showLogin({innerWidth: 'auto', close: '关闭'});
      //$(document).bind('after_logged_in', function(){
      //  vote2(id, v);
      //})
    }
    return false;
}

$(function(){
  $('.arrow').click(function(){
    var v = -1, id = $(this).attr('id').match(/\d+/);
    if(!id) return false;
    id = parseInt(id[0])
    if($(this).hasClass('up')){
      v = 1;
    }
    return vote2(id, v, $(this).attr('href'));
  })
})


//Favorite ////////////////////////////////////////////////////////////////

$(function(){
    $('.favorite-button a').live('click',function(){
      var e = $(this), p = e.parent(), href=e.attr('href');

      if ( href!="/login" ){
          p.load(href, function(text){
            p.html($("<div>").append(text).find("."+p.attr('class')).html());
          })
          return false;
      }else{return true;}
    });
    $('input.numeric').keydown(function(e){
        var k = e.keyCode;
        if(((k>47)&&(k<58)) ||
            (k == 8) ||
            (k == 46)||
            (k == 13)||
            (k>=96 && k<=105)){
            //            event.returnValue = true;
            return true;
        } else {
            e.returnValue = false;
            return false;
        }
    });
    /*
    $('textarea').live('change keypress', function(){
      if(this.scrollHeight>50){
        this.style.height=this.scrollHeight+'px';
      }
    })*/
    if($.browser.msie){
      $('.article').hover(function(){$(this).toggleClass('hover')})
    }
});

// Comment //////////////////////////////////////

function postComment(){
    var f = this, e = $('.comment_submit', f), fe = $(f);
    var v = $.trim(fe.find('.comment_input').val());
    if(v == ''){
        return false;
    }

    $.post(f.action, fe.serialize(), function(data){
        e.val('\u53d1\u8868\u8bc4\u8bba').attr('disabled', false);
        fe.find(".comment_input").val('').height('50px');
        var comments = $('#comments_'+fe.attr('data-article_id')),u = comments.children('ul');
        if(u.size()>0){
          $(data).hide().appendTo(u).slideDown();
        }
        else{
          $('<ul style="display:none">'+data+'</ul>').prependTo(comments).slideDown();
        }
    });
    e.val('\u6b63\u5728\u53d1\u8868');
    e.attr('disabled', 'disabled');

    return false;
}

function loadComments(e){
  var l = $(this), article = l.parents('.article:first'), post = l.parents('.post:first');
  var oid = l.attr('id'), id = /\d+/.exec(oid);
  if(!id) return;
  id = id[0];
  var comments_el = $('#comments_'+id);
  if(comments_el.size() == 0){
      var xx = l.html();
      l.text('...');
      $.get(l.data('path'), null, function(data){
          $(data).hide().appendTo(article.toggleClass('expanded')).slideDown();
          l.html(xx).trigger('loaded');
      });
  }else{
    if(article.hasClass('expanded')){
      comments_el.slideUp(function(){
        article.removeClass('expanded')
      });
    }else{
      article.addClass('expanded')
      comments_el.slideDown();
    }
  }
  $.scrollTo(l, 'slow', {axis: 'y', offset: -100})
  l.attr('id', '')
  window.location.hash = oid;
  setTimeout(function(){l.attr('id', oid)}, 0)
  l.blur();
  e.preventDefault();
  return false;
}
function showall(id){
  $('.hide', '#comments_'+id).toggle();
}

$(function(){
    $('.reply_form form').live('submit', postComment);
    //$('.comment_input').live('click', clear_warning).live('mouseover', clear_warning);
    $('a.comments').click(loadComments);
    var hash=window.location.hash;
    if(hash.indexOf('#c-') === 0){
        $(hash).click();
    }
});

$(document).keypress(function(e){
  if((e.ctrlKey || e.metaKey) && (e.which == 13 || e.which == 10)) {
    var o=e.target;
    //console.debug(o)
    //console.debug(o.form)
    if(o.form){
      $(o.form).submit();
    }
  }
});

function replyComment(comment_id, article_id, floor){
  var form = $('form', '#comments_'+article_id), c = $('#post_'+comment_id);
  $('input[name="comment[parent_id]"]',form).val(floor);

  var t = $('textarea', form),o = t.val();
  nv = '\u56de\u590d'+floor+'L:'+ o;
  t.val(nv);
  $.scrollTo(form, 1000, {axis:'y', offset: -60});
  t.focus();
  t.setCursorPosition(nv.length);
}

$(function() {
return $('a.more').click(function() {
var article, id, post, self = $(this);
article = self.parents(".article:first");
post = self.parents(".post:first");
id = post.attr('id');
$.get(self.attr('href'), function(data) {
return post.html($("<div>").append(data).find(".top_post").html());
});
return false;
});
});

$(function(){
  $('a.picture').live('click', function() {
    $(this).colorbox({open:true});
    return false;
  });
  $('.need-login').live('click', function(){
    sr.showLogin({innerWidth: 'auto', close: '关闭'});
    return false;
  });

})

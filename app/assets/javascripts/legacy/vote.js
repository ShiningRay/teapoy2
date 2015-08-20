//= require 'sr'
//= require 'ajaxlogin'
//= require 'plugins/particle'

$(function(){
  var colors =  ['red', 'green', 'blue', 'cyan', 'purple', 'yellow', 'orange'];

  var minus_emitter = new particle_emitter({
    image: function(){
      return $('<div style="position:absolute;overflow:visible">-1</div>').css({
        'font-size': (Math.random()*20+5)+'px',
        'color': colors[Math.floor(Math.random() * colors.length)]
      });
    },
    end: {'font-size': '1px', 'width': '20px', 'height': '10px'},
    center: ['50%', '50%'],
    size: 15,

    velocity: 40,
    decay: 800,
    rate: 10,
    easing: 'swing'
  });

  var pos_emitter = new particle_emitter({
    image: function(){
      return $('<div style="position:absolute;overflow:visible">+1</div>').css({
        'font-size': (Math.random()*20+5)+'px',
        'color': colors[Math.floor(Math.random() * colors.length)]
      });
    },
    end: {'font-size': '1px', 'width': '20px', 'height': '10px'},
    center: ['50%', '50%'],
    size: 15,
    velocity: -40,
    radius: 30,
    decay: 800,
    rate: 10,
    easing: 'swing'
  });

  $('.post').on('click', '.arrow', function(event){
    var el = $(this);
    if (!sr.isLoggedIn()) {
      return sr.showLogin();
    }
        //showcover(true, 'vote_' + $(this).thing_id());
    //} else  {
        //var things = $(this).all_things_by_id();
    var post = sr.post(this),
        votecell = el.parent(),
        dir = (el.hasClass('up') ? 1 : (el.hasClass('down')? -1 : 0)),
        voted = (votecell.hasClass('likes') ? 1 : (votecell.hasClass('dislikes') ? -1 : 0)),
        score_el = votecell.children(".score"), score = parseInt(score_el.text());
        //console.debug(post);
    if(post.hasClass('mine')){
      return;
    }
    $.post('/posts/'+sr.id(post)+'/'+(dir > 0 ? 'up' : 'dn'));
    if(voted === 0){
      if(dir > 0){
        score++;
        votecell.addClass('likes').removeClass('dislikes unvoted');
      } else if (dir == -1) {
        score--;
        votecell.addClass('dislikes').removeClass('likes unvoted');
      }
    } else {
      votecell.removeClass('likes dislikes').addClass('unvoted');
      if(voted == 1){
        score--;
      }else{
        score++;
      }
      if(dir != voted){
        if(dir == 1){
          score++;
          votecell.addClass('likes').removeClass('dislikes unvoted');
        } else if (dir == -1) {
          score--;
          votecell.addClass('dislikes').removeClass('likes unvoted');
        }
      }
    }
    score_el.text(score);
    var pos = score_el.offset();
    //star_emitter.startOnce(500, pos.left + score_el.width()/2, pos.top+score_el.height()/2);
    /*if(dir != 0 ){
      play(score_el, dir)
    }*/
    pos.left += score_el.width() / 2;
    pos.top +=  score_el.height() / 2;
    if(dir > 0){
      pos_emitter.startOnce(500, pos.left, pos.top);
    }else{
      minus_emitter.startOnce(500, pos.left, pos.top);
    }
    //}
    event.stopPropagation();
    event.stopImmediatePropagation();
    return false;
  });
});

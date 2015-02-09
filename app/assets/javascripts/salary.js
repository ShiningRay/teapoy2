//= require 'plugins/particle'
//= require 'plugins/parabola'
//= require 'vendor/soundmanager2-nodebug-jsmin'

$(function(){
  var sound;
  soundManager.onready(function(){
    sound = soundManager.createSound({
      id: 'coin',
      url: '/au/coin.mp3',
      autoLoad: true,
      autoPlay: false
    });
  })
  var stars = $.map(['red', 'orange', 'yellow', 'green', 'cyan', 'blue', 'purple'], function(e){
                  return '/images/star/'+e+'.gif';
                });
  var salary_elem = $('#salary'), pos = salary_elem.offset();
  if(salary_elem.size() == 0){
    return;
  }
  pos.left = pos.left+salary_elem.width()/2;
  pos.top = pos.top+salary_elem.height();
  var star_emitter = new particle_emitter({
      image: stars,
      center: [pos.left, pos.top],
      size: 40,
      velocity: 40,
      decay: 800,
      rate: 20,
      easing: 'swing',
      className: 'star-particle'
  });

  function salaryAnimation(elem, amount){
    var pos1 = $(elem).offset();
    var e1 = $('<div>'+amount+'</div>').appendTo('body').css({position: 'absolute', 'font-size':'20px', 'color':'red'}).offset(pos1);
    if(sound) sound.play();
    new Parabola(e1, pos1, pos, 300, function(){
      e1.remove();
      salary_elem.text(parseInt(salary_elem.text()) + amount);
      star_emitter.startOnce(500);
    })
  }
  $('.salaries').on('click', 'a.get_salary', function(){
    var myself = $(this);
    $.ajax({
      type: "post",
      url: myself.attr("href"),
      dataType :"json",
      success: function(data) {
      if (data.status) {
        if (data.salary > 0) {
            salaryAnimation(myself.parent(), data.salary);
            myself.fadeOut(1000);
            }
        else{
         alert("您已经领过工资了，工资虽好，可不要贪心哦～^_^");
         myself.parent().fadeOut(1000);
        }
          }
      else{
         alert("由于某种不可控的原因，工资领取失败了.你回去好好反省反省自己的行为吧 (⊙o⊙)");
         myself.parent().fadeOut(1000);
      }
      }
  });
  return false;
});
});

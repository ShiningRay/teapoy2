//= require "vendor/soundmanager2-nodebug-jsmin"
//= require "vendor/fireworks"
//= require "jquery/snowfall.jquery"

$(function(){
  //fireworks init
  $('body').append('<div id="fireworks-template"/><div id="fw" class="firework"/><div id="fp" class="fireworkParticle"><img src="/images/particles.gif" alt=""/></div><div id="fireContainer"/>');
  $('head').append('<link href="/stylesheets/fireworks.css" media="screen" rel="stylesheet" type="text/css" />');
//$('<div style="height:300px;" id="welcome"></div>').insertAfter("#top");


//$(document).ready(function() {
// setTimeout("$('#welcome').slideUp(3000);",5000);
//});
  function letitsnow(){
     $(document).snowfall({
      flakeCount : 100,
      flakeColor : '#ffffff',
      flakeIndex: 999999,
      minSize : 10,
      maxSize : 20,
      minSpeed : 2,
      maxSpeed : 5,
      round : true});
    $.cookie("weather", 'snow',{expires: 7, path: "/"});
  }

  function letitsunny(){
    $(document).snowfall('clear');
    $.cookie("weather", null, {path: '/'});
  }
  var weather = $.cookie("weather");
  var pic = 'sun';
  if (weather === null || weather === "sun"){
    pic = 'snow';
  }

  var li = $('<li class="snow"><img src="/images/'+pic+'.png" style="cursor:pointer" width="16" height="16" /></li>').prependTo('#topnavright > ul');

  if(weather === "snow"){
   $(window).load(letitsnow);
 }
  $(document).dblclick(function(e) {
    var x = e.pageX * 100.0 / $(window).width();
    var y = (e.pageY - $(document).scrollTop()) * 100.0 / $(window).height();
    createFirework(null,150,null,null,null,null, x, y,false,true);
  });
  li.click(function(){
    var weather = $.cookie("weather");
    if(weather === null || weather == 'sun') {
      $(this).children("img").attr("src","/images/sun.png");
      letitsnow();
    } else {
      $(this).children("img").attr("src", "/images/snow.png");
      letitsunny();
    }
    return false;
  });
});

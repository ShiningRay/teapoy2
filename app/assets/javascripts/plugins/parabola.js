function Parabola(elem, start, end, duration, callback){
  //var vx = (end.left - start.left) / duration;
  var ay = (end.top - start.top) * 2.0 / (duration * duration);

  return $(elem).animate(
        {left: end.left},
        {duration: duration,
         step: function(now,fx){
            if(fx.prop=='left'){
              $.style(fx.elem, 'left', fx.now + fx.unit);
              var t = fx.options.duration * fx.pos;
              $.style(fx.elem, 'top', (start.top + ay * t * t / 2.0) + fx.unit);
            }
          },
          easing: 'linear',
          complete: callback});
}

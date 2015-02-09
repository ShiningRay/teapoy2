/*
Particle Emitter JavaScript Library
Version 0.3
by Erik Friend

Creates a circular particle emitter of specified radius centered and offset at specified screen location.  Particles appear outside of emitter and travel outward at specified velocity while fading until disappearing in specified decay time.  Particle size is specified in pixels.  Particles reduce in size toward 1px as they decay.  A custom image(s) may be used to represent particles.  Multiple images will be cycled randomly to create a mix of particle types.

example:
var emitter = new particle_emitter({
    image: ['resources/particle.white.gif', 'resources/particle.black.gif'],
    center: ['50%', '50%'], offset: [0, 0], radius: 0,
    size: 6, velocity: 40, decay: 1000, rate: 10
}).start();
*/

particle_emitter = function (opts) {
    // DEFAULT VALUES
    var defaults = {
        center: ['50%', '50%'], // center of emitter (x / y coordinates)
        offset: [0, 0],         // offset emitter relative to center
        radius: 0,              // radius of emitter circle
        image: 'particle.gif',  // image or array of images to use as particles
        size: 1,                // particle diameter in pixels
        velocity: 10,           // particle speed in pixels per second
        decay: 500,             // evaporation rate in milliseconds
        rate: 10,                // emission rate in particles per second
        easing: 'linear'
    };
    // PASSED PARAMETER VALUES
    var _options = $.extend({}, defaults, opts);

    // CONSTRUCTOR
    var _timer, _margin, _distance, _interval, _is_chrome = false, _emitting = false;
    (function () {
        // Detect Google Chrome to avoid alpha transparency clipping bug when adjusting opacity
        if (navigator.userAgent.indexOf('Chrome') >= 0) _is_chrome = true;

        // Convert particle size into emitter surface margin (particles appear outside of emitter)
        _margin = _options.size / 2;

        // Convert emission velocity into distance traveled
        _distance = _options.velocity * (_options.decay / 1000);

        // Convert emission rate into callback interval
        _interval = 1000 / _options.rate;
    })();

    // PRIVATE METHODS
    var _sparkle = function () {
        // Pick a random angle and convert to radians
        var rads = (Math.random() * 360) * (Math.PI / 180);

        // Starting coordinates
        var sx = parseInt((Math.cos(rads) * (_options.radius + _margin)) + _options.offset[0] - _margin);
        var sy = parseInt((Math.sin(rads) * (_options.radius + _margin)) + _options.offset[1] - _margin);

        // Ending Coordinates
        var ex = parseInt((Math.cos(rads) * (_options.radius + _distance + _margin + 0.5)) + _options.offset[0] - 0.5);
        var ey = parseInt((Math.sin(rads) * (_options.radius + _distance + _margin + 0.5)) + _options.offset[1] - 0.5);

        // Pick from available particle images
        var image = _options.image, s;
        if (typeof(image) == 'function'){
          s = image(_options);
        } else {
          if($.isArray(image)){
            image = image[Math.floor(Math.random() * image.length)];
          }

          s = $('<img>').attr('src', image);
        }
 // Attach sparkle to page, then animate movement and evaporation
        var end = $.extend({
            width: '1px',
            height: '1px',
            marginLeft: ex + 'px',
            marginTop: ey + 'px',
            opacity: 0
        }, _options.end);
        s.css({
              zIndex:     10,
              position:   'absolute',
              width:      _options.size + 'px',
              height:     _options.size + 'px',
              left:       _options.center[0],
              top:        _options.center[1],
              marginLeft: sx + 'px',
              marginTop:  sy + 'px'
          }).appendTo('body').animate(end,
          _options.decay,
          _options.easing,
          function () {
            //$(this).remove();
          });
        if(_options.className){
            s.addClass(_options.className);
        }
        // Spawn another sparkle
        if(_emitting){
            _timer = setTimeout(function () { _sparkle(); }, _interval);
        }
    };

    // PUBLIC INTERFACE
    // This is what gets returned by "new particle_emitter();"
    // Everything above this point behaves as private thanks to closure
    return {
        start:function () {
            _emitting = true;
            clearTimeout(_timer);
            _timer = setTimeout(function () { _sparkle(); }, 0);
            return(this);
        },
        stop:function () {
            _emitting = false;
            clearTimeout(_timer);
            return(this);
        },
        startOnce: function(duration, x, y, callback){
            if(x && y){
              this.centerTo(x,y)
            }
            this.start();
            clearTimeout(this._onceTimer);
            var self = this;
            this._onceTimer = setTimeout(function(){
              self.stop();
              if(typeof callback == 'function'){
                callback.call(self);
              }
            }, duration);
            return(this);
        },
        centerTo:function (x, y) {
            _options.center[0] = x;
            _options.center[1] = y;
        },
        offsetTo:function (x, y) {
            if ((typeof(x) == 'number') && (typeof(y) == 'number')) {
                _options.center[0] = x;
                _options.center[1] = y;
            }
        }
    }
};

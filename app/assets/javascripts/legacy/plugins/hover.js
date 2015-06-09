// Add hover class when mouse hover
// for old browsers

(function($){
  $.fn.extend({
    autoHoverClass: function(){
      this.hover(function(){$(this).addClass('hover');}, function(){
        $(this).removeClass('hover');
      });
    }
  });
})(jQuery);

function autoHoverClass(selector, context) {
  $(context || 'body').on({
    mouseenter: function(){
      var self = $(this);
      //debug('enter')
      //debug(self.attr('class'))
      setTimeout(function(){
        self.addClass('hover');
      }, 0);
    },
    mouseleave: function(){
      var self = $(this);
      setTimeout(function(){
        self.removeClass('hover');
      }, 0);
    }
  }, selector);
}

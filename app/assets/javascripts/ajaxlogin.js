//= require 'sr'
//= require 'jquery/colorbox'

sr.showLogin = function(options) {
  options = $.extend({
        inline: true,
        href: "#login-form",
        innerWidth: 400,
        open: true,
        scrolling: false
    }, options);
  if($('#login-form').size() === 0){
    options.inline = false;
    options.href = '/login';
  } else {

  }
  if($('html').hasClass('lt-ie9')){
    options.onComplete = function(){
      setTimeout(function(){
        $('#cboxLoadingOverlay').hide();
        $('#cboxLoadingGraphic').hide();
      }, 500);
    };
  }
  $.colorbox(options);
};

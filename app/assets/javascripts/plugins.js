//= require jquery.atwho
//= require select2
//= require "jquery/colorbox"
//= require 'jquery/poshytip'
//= require "jquery/ba-throttle-debounce"
//= require "jquery/scrollTo"
//= require 'jquery/slides.min.jquery'
//= require 'ajaxlogin'
//= require "jquery/jquery.cookie"
//= require "jquery/countdown"
//= require "jquery/insertAtCaret"
// require "jquery/lazyload"
// usage: log('inside coolFunc', this, arguments);
// paulirish.com/2009/log-a-lightweight-wrapper-for-consolelog/

window.log = function(){
  log.history = log.history || [];   // store logs to an array for reference
  log.history.push(arguments);
  if(this.console) console.log( Array.prototype.slice.call(arguments) );
};

///{{{ setCursorPosition
(function($) {
  $.fn.setCursorPosition = function(pos) {
    var e = this;
    if (this.setSelectionRange) {
      this.setSelectionRange(pos, pos);
    } else if (this.createTextRange) {
      var range = this.createTextRange();
      range.collapse(true);
      range.moveEnd('character', pos);
      range.moveStart('character', pos);
      range.select();
    }
  };
})(jQuery);
///}}}


// Ctrl-Enter to submit form
$(function(){
	$("body").on('keypress', "textarea", function(event){
		if( (event.ctrlKey || event.metaKey) && event.which == 13 || event.which == 10){
			$(this.form).submit();
		}
	});
});


/*
// place any jQuery/helper plugins in here, instead of separate, slower script files.
jQuery.fn.absolutize = function(placeholder)
{
  return this.each(function(zi)
  {
    var element = jQuery(this);
    //element.clone(false, false).attr('id', '').css('visibility', 'hidden').insertAfter(element);
    if (element.css('position') == 'absolute')
    {
      return element;
    }

    var width = element.width();
    var height = element.height();
    var pos = element.position();
    if(placeholder){
      var css = {'border-color': 'transparent', 'visibility': 'hidden'};
      var keys =['float', 'display', 'width', 'height', 'margin-top', 'margin-right', 'margin-bottom', 'margin-left', 'padding-top', 'padding-right', 'padding-bottom', 'padding-left', 'border-top-width', 'border-right-width', 'border-bottom-width', 'border-left-width',
           'border-top-style', 'border-right-style', 'border-bottom-style', 'border-left-style'];
      for(var i = 0, l = keys.length;i<l;i++){
        css[keys[i]] = element.css(keys[i]);
      }

      $('<div/>').css(css).insertAfter(element);
    }
    element.data('originalPosition', pos);
    element.data('originalSize', {width: width, height: height});
    //element._originalLeft = element.left - parseFloat(element.css("left") || 0);
    //element._originalTop = top - parseFloat(element.css("top") || 0);
    //element._originalWidth = element.css("width");
    //element._originalHeight = element.css("height");

    return element.css({
      'z-index': zi,
      "position": "absolute",
      "top": pos.top + 'px',
      'left': pos.left + 'px',
      'width': width + 'px',
      'height': height + 'px'
    });
  });
}
*/
//:javascript
/*
  $(function(){
    $($('.groups-list .group').get().reverse()).mouseenter(function(){
      var e = $(this);
      if(this.scrollHeight > e.outerHeight()){
        $(this).animate({height: this.scrollHeight});
      }
    }).mouseleave(function(){
      $(this).animate({height: $(this).data('originalSize').height});
    }).absolutize(true);
  });*/

(function($){
  $.fn.extend({
    outerHtml: function(){
    var tmp_node = $("<div></div>").append( $(this).clone() );
    var markup = tmp_node.html();
    // Don't forget to clean up or we will leak memory.
    tmp_node.remove();
    return markup;
    }
  });
})(jQuery);

// Enable omni form
$(function(){

  $('.extra_fields input, .extra_fields textarea').attr('disabled', 'disabled');
  $('#topic_top_post_attributes_type_input input[type=radio]').change(function(){
    var e = $(this);
    if(e.val() === ''){
      return;
    }
    $('.current_extra_fields').removeClass('current_extra_fields');
    var i = $('#'+e.val().toLowerCase()+'_fields').addClass('current_extra_fields');
    $('input,textarea', i).removeAttr('disabled');
    //console.debug(this);
    //console.debug(e)
  });
  $('#topic_top_post_attributes_type_input input[type=radio]:checked').change();
});

//$("#post_content").Face({left : "30" , top : "1" });

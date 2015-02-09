/**
    Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php

    Copyright (c) 2010 Cao Li <shiningray.nirvana@gmail.com>

    Permission is hereby granted, free of charge, to any person
    obtaining a copy of this software and associated documentation
    files (the "Software"), to deal in the Software without
    restriction, including without limitation the rights to use,
    copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following
    conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
    OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
    HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
    OTHER DEALINGS IN THE SOFTWARE.

    Example
    $(document).ready(function(){
      $('.blink').blink()
    })
 */

(function($){

  function blinkFadeIn(obj){
    if(!obj){
      obj = $(this)
    }
    obj.animate({opacity: 1}, 500, 'linear', obj.data('blinking') && blinkFadeOut);
  }
  function blinkFadeOut(obj){
    if(!obj){
      obj = $(this);
    }
    obj.animate({opacity: 0.1}, 500, 'linear', blinkFadeIn);
  }

  $.fn.extend({
    blink: function(options){
      if(options=='stop'){
        return this.removeData('blinking').stop().clearQueue().css('opacity', '');
      }
      return this.hover(function(){
        $(this).data('blinking', true);
        blinkFadeOut($(this));
      }, function(){
        $(this).removeData('blinking');
      });
    }
  });
})(jQuery);

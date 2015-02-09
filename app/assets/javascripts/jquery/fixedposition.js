//= require 'jquery/ba-throttle-debounce'
/*

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
================================================================================
    This will automaticly test if the browser support fixed position
    you can pass true as an argument to bypass the test

    Example
    $(document).ready(function(){
      $('.fixed').fixedPosition()
    })
 */

;(function($){
	var _support;
	function supportsPositionFixed() {
		if (typeof _support === "undefined") {
			var _body = $('body');
	        _body.append( '<style>span#supportsPositionFixed{position:fixed;width:1px;height:1px;top:25px;}</style>');
	        _body.append( '<span id="supportsPositionFixed"></span>' );
	        var offset = $("#supportsPositionFixed").offset();
	        $("#supportsPositionFixed").remove();
	        _support = Boolean(offset.top === 25);
		}
		return _support;
    };
	var fixQueue =[];

	function fixall(force) {
		if(!force && supportsPositionFixed()){
			return this.css('position', 'fixed');
		}
		return this.each(function(){
			var e = $(this);
			fixQueue.push(this);
			e.css('position', 'absolute').data('originalOffset', e.offset());
		});
	}
	$.fn.fixedPosition = fixall;
	$(function(){
		$(window).scroll($.debounce(200, function(){
			var sTop = $(this).scrollTop(), sLeft = $(this).scrollLeft();
			$.each(fixQueue, function(){
				var original = $(this).data('originalOffset');
				$(this).css({top:original.top+sTop, left:original.left+sLeft})
			}))
		})
	})
})(jQuery);
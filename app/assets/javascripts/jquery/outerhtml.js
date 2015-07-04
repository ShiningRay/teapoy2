// outerhtml.js

// (function ($) {
//   $.fn.outerHTML = function () {
//     return $(this).clone().wrap('<div></div>').parent().html();
//   };
// })(jQuery);


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
// outerhtml.js

(function ($) {
  $.fn.outerHTML = function () {
    return $(this).clone().wrap('<div></div>').parent().html();
  };
})(jQuery);
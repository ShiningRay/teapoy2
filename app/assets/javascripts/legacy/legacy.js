//= require './plugins/blink'


// show blinking in up vote and down vote button
$(function () {
  if (!isIE6()) {
    $('.unvoted .arrow').blink().click(function () {
      $(this).blink('stop');
    });
  }
});

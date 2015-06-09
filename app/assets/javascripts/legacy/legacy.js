//= require './plugins/blink'


// show blinking in up vote and down vote button
$(function () {
  if (!isIE6()) {
    $('.unvoted .arrow').blink().click(function () {
      $(this).blink('stop');
    });
  }
});
// 
// #鼠标移到评论区域，才显示回复，删除等等链接
// #$(function(){
// #   $("ul.comments li").hover(function(){
// #     $(this).find(".operator").show();
// #   },function(){
// # $(this).find(".operator").hide();
// #   });
// #})
// #

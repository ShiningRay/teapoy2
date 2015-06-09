// support in IE
$(function(){
  $('input, textarea').placeholder();
});

function isIE6() {
  return $('html').hasClass('ie6');
}

$(function(){
  if(isIE6()){
    $('.fixed').fixedPosition();
  }
});

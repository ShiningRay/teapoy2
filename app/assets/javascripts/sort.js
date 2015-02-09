//# require "jquery.ui"
//# require "jquery.ui.datepicker-zh-CN"
// TODO: what's this
$(function(){
  return;
  $(document).ready(function(){
    $('#items').sortable({
      axis: 'y',
      dropOnEmpty: false,
      handle: '.handle',
      cursor: 'crosshair',
      items: 'li',
      opacity: 0.4,
      scroll: true,
      update: function(){
        $.ajax({
          type: 'post',
          data: $('#items').sortable('serialize'),
          dataType: 'script',
          complete: function(request){
            $('#items').effect('highlight');
          },
          url: '/lists/'+list_id+'/sort'})
      }
    });
    $(".datepicker").datepicker();
  });
})

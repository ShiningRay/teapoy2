$(function(){
 highlight = function(a, fun) {
     return $.scrollTo(a, 500, {
       offset: -100,
       onAfter: function() {
         if (fun) fun(a);
         return a.effect("highlight", 3000);
       }
     });
   };
 $("#notifications_list li a").live("click", function() {
     var topic, self;
     self = $(this).parent();
     topic = $("#topic_"   self.data("topic_id"));
     if (topic.size() === 0) {
       $.ajax({
         type:"get",
         url:self.data("topic_url"),
         success:function(data){
          $(data).prependTo(".mj-topics");
         }
       });
      self.dismiss();
     } else {
       highlight(topic, (function() {
         if (self.data('scope') === 'reply' && $('.comment', topic).size() < parseInt(self.data('comments_count'))) {
           $('.comments_topic', topic).remove();
           $('a.comments', topic).click();
         }
         return self.dismiss();
       }));
     }
     return false;
   });
})

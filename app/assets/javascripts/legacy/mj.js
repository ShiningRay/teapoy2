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
     var article, self;
     self = $(this).parent();
     article = $("#article_"   self.data("article_id"));
     if (article.size() === 0) {
       $.ajax({
         type:"get",
         url:self.data("article_url"),
         success:function(data){
          $(data).prependTo(".mj-topics");
         }
       });
      self.dismiss();
     } else {
       highlight(article, (function() {
         if (self.data('scope') === 'reply' && $('.comment', article).size() < parseInt(self.data('comments_count'))) {
           $('.comments_article', article).remove();
           $('a.comments', article).click();
         }
         return self.dismiss();
       }));
     }
     return false;
   });
})

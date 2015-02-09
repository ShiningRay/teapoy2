// @charset "utf-8";
//= require 'jquery/scrollTo'
//= require 'jquery/autoresize'
//= require "jquery/ba-throttle-debounce"
//= require "templates"
//= require "views/new_comments"
//= require "views/new_comment"
//= require 'old_comment'
//= require "views/new_comments_withouts_form"
$(function () {
  if(window.COMMENTS) return;
  window.COMMENTS = true;
  if(!$('body').hasClass('my-inbox') && !$('body').hasClass('my-latest')){
    return false;
  }
  $('#content').on('click', "a.show-someone-comment",function(){
    show_comment_of($(this),$(this).data("login"));
    var data_login = $(this).data("login");
    sr.article(this).find("a.show-someone-comment[data-login="+data_login+"]").text("展开其他").addClass('show_all_comments').removeClass("show-someone-comment");
    $.scrollTo(sr.article(this), 1000, {
      offset: {
        top: 100
      },
      axis: 'y'
    });
    return false;
  })

  $('#content').on('click', "a.show_all_comments",function(){
     show_all(sr.article(this).attr("id").split("_")[1]);
     var  data_login = $(this).data("login");
     sr.article(this).find("a.show_all_comments[data-login="+data_login+"]").text("只看此人").addClass('show-someone-comment').removeClass("show_all_comments");
     $.scrollTo(sr.article(this), 1000, {
      offset: {
        top: 100
      },
      axis: 'y'
    });
     return false;
  })

  function replyComment(comment_id, article_id, flr) {
    if (!sr.isLoggedIn()) {
      return sr.showLogin();
    }
    var article = $("#comments_article_" + article_id);
    var editorTextPosition = -1;
    var commentArea = $('#post_content', article);
    var editorPositionFunc = function() {
        editorTextPosition = $(this).textPosition();
      };
     commentArea.mouseup(editorPositionFunc).keyup(editorPositionFunc);
    if (editorTextPosition == -1) {
        editorTextPosition = commentArea.textPosition();
    }
    var floor = $('#post_parent_id', article).val();
    if (parseInt(floor) > 0){
       $('#post_content', article).textPosition($('#post_content', article).val().length,"  @"+$.trim($('#post_' + comment_id + ' .nickname').text()));
       $('#post_content', article).focus();
    }else{
      $('#post_parent_id', article).val(flr);
      //var nv = '回复' + flr + 'L ' + $.trim($('#post_' + comment_id + ' .nickname').text()) + ': ';
      $('#post_content', article).val(nv + $('#post_content', article).val()).focus().setCursorPosition(nv.length);
    }
  }
  $('#content').on('click', 'a.reply', function(){
    var e= $(this);
    replyComment(e.data('id'),e.data('article_id'),e.data('floor'))
  })
  $('form#new_post').autoResize({
    animate: true,
    animateDuration: 600,
    extraSpace: 0
  });

  $("#tailake").on('click', "a.show_readed",function(){
    var myself = $(this);
    if (myself.hasClass('loading')){
      return false;
    }
    var comment = myself.next();
    if (comment.hasClass("unread")){
      myself.addClass('loading')
      $(this).removeClass("show_readed").addClass("hide_readed");
      var comment_url = myself.attr("href").split("?")[0] + "/comments?before=" + comment.data("floor");
      $.ajax({
        type:"get",
        dataType: "json",
        url:comment_url,
        success:function(data){
         $(window.templates.render('new_comments_withouts_form', {"comments":data})).insertAfter(myself).css('display','block');
         myself.removeClass('loading')
        }
      });
    }
   return false;
  })

  $('#content').on('submit', 'form#new_post', function () {
    if ($.trim($('textarea', this).val()) == '' && $('input[type=file]').val() == '') {
      return false;
    }
    var submit_botton = $('form#new_post input[type=submit]');
    var f = $(this);
    submit_botton.attr('disabled', "disabled");
    submit_botton.val('...');
    if ($('input[type=file]', f).val() == '') {
      $.ajax({
        type: "POST",
        url: f.attr('action').replace(".html",".json"),
        data: f.serialize(),
        dataType:"json",
        success: function (data) {
          //console.debug(xhr)
          $(window.templates.render('new_comment',data)).appendTo(f.parents(".comments_article:first").find("ul.comments")).hide().slideDown(500);
          submit_botton.removeAttr('disabled');
          submit_botton.val('回复');
          f.clearForm();
          $('#post_parent_id', f).val("");
        }
      });
    } else {
      $('input[name=from_xhr]', f).val(1);
      $(this).ajaxSubmit({
        dataType: "json",
        url: $(this).attr('action').replace(".html",".json"),
        // data: $.extend({from_xhr:true}, f.formSerialize()),
        success: function (data) {
          //console.debug(data)
          //  alert(data);
          $(window.templates.render('new_comment',data)).appendTo(f.parents(".comments_article:first").find("ul.comments")).hide().slideDown(500);
          submit_botton.removeAttr('disabled');
          submit_botton.val('回复');
          f.clearForm();
          $('#post_parent_id', f).val("");
          $('input[type=file]', f).val("");
        }
      });
    }
    return false;
  });
  $(".articles-list").on('click', "li.comment-status a",function(){
       var A = $(this);
       var article = A.parents(".article:first")
       var comments = $(".comments_article",A.parents(".article:first"));
       if (comments.length > 0)
           {
              comments.toggle();
              comments.find("li.comment").each(function () {
                $(this).show();
              })
              return false;
           }
       else
          {
              A.text("...");
              var article_id = A.attr("id").split("-")[1];
              var group_alias = A.attr("href").split("/")[1];
              $.ajax({
                type: "get",
                dataType : "json",
                url: A.attr('href').split("#")[0]+"/comments.json",
                success: function(data, status, xhr){
                  //console.debug(xhr)
                  if(xhr.status == 200){
                     $(window.templates.render("new_comments",{"article_id":article_id,"group_alias":group_alias,"comments":data})).appendTo(article);
                     if (article.find("ul.comments li.comment").length > 0 )
                     {
                       A.text(article.find("ul.comments li.comment").length +"条评论");
                     }
                     else{
                       A.text("暂无评论");
                     }
                  } else {
                    alert(xhr.responseText) ;
                  }
                }
              });
              var read_comments = article.find("ul.comments li.comment.read").length
              if (read_comments > 0 ){
                article.find("a.show_readed").text("已经折叠了"+read_comments+"个已读评论").show();
              }
             return false;
          };
  });

  //查看某人对帖子的评论
  function show_comment_of(me, user_login) {
    var target = "user-" + user_login;
      to_show = [],
      to_hide = [];
     me.parents(".comments_article:first").find("ul.comments li.comment").each(function () {
      if (this.className.indexOf(target) >= 0) {
        to_show.push(this);
      } else {
        to_hide.push(this);
      }
    });
    $(to_show).slideDown(500);
    $(to_hide).slideUp(500);
  }
  function show_all(article_id) {
    var a = $("#comments_article_" + article_id).find("ul.comments li");
    if (a.size() < 50) {
      a.slideDown(500);
    } else {
      a.show();
    }
  }

  $("#content").on("change", "select#user_login", function () {
    var me = $(this);
    if (me.val() != "") {
      show_comment_of(me, me.val());
    }
  });

  $('.in-reply-to').click(function () {
    var target = $(this).attr('href').replace('#', '');
    var fl = $("." + target);
    if (fl.is(":hidden")) fl.slideDown(1000);
    $.scrollTo(fl, 1000, {
      offset: {
        top: -100
      },
      axis: 'y'
    });
    return false;
  }).poshytip({
    className: 'tip-green',
    //      alignTo: 'target',
    offsetX: -7,
    offsetY: 16,
    liveEvents: true,
    content: function () {
      var target = $(this).attr('href').replace('#', '');
      return($('.'+target,$(this).parents("ul.comments:first")).html());
    }
  });
  $('.comment .reply').poshytip({
    liveEvents: true,
    className: 'tip-green',
    offsetX: -7,
    offsetY: 16,
    content: function () {
      var result = "";
      var commented = $(".comment[data-parent_id="+$(this).data('floor')+"]",$(this).parents("ul.comments:first"));
      if (commented.length) {
        commented.each(function () {
          result += $(this).html();
        })
      } else {
        result = "暂时没有针对这条评论的回复";
      }
      return result;
    }
  });
  $("#content").on('click', "a.show_readed", function () {
    var myself = $(this);
    if (myself.hasClass('loading')){
      return false;
    }
    var read = myself.nextAll("li.read");
    if (read.size() < 50) {
      read.slideDown(500)
    } else {
      read.css('display', 'block');
    }
    myself.removeClass("show_readed").addClass("hide_readed");
    return false;
  });
  $('#content').on('click', "a.hide_readed", function () {
    var read = $(this).nextAll("li.read");
    if (read.size() < 50) {
      read.slideUp(500);
    } else {
      read.css('display', 'none')
    }
    $(this).removeClass("hide_readed").addClass("show_readed");
    return false;
  });
  $('#content').on('click', 'a.show_all', function(){
    show_all(sr.article($(this)))
  })
})



//鼠标移到评论区域，才显示回复，删除等等链接
//$(function(){
//   $("ul.comments li").hover(function(){
//     $(this).find(".operator").show();
//   },function(){
// $(this).find(".operator").hide();
//   });
//})
//

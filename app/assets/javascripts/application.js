// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//# require turbolinks
//# require turbolinks.redirect
//= require jquery.remotipart
//# require jquery.turbolinks
//= require "plugins"
//= require 'templates'
//= require "sr"
//= require 'version'
// require "repost"
//= require "old_comment"
//= require "vote"
//= require "video"
//= require "usercard"
//= require "subscribe"
//= require "more"
//= require "ajaxlogin"
//= require "form"
//= require 'group'
//= require 'salary'
//= require 'notification'
//= require 'poll'
// require "sort"
// require  "xmas"
//= require 'jquery/jquery.url'
//= require bootstrap-sprockets

if (soundManager) {
  soundManager.url = '/';
  soundManager.preferFlash = false;
}

(function ($) {
  $.fn.outerHTML = function () {
    return $(this).clone().wrap('<div></div>').parent().html();
  };
})(jQuery);

$(function () {
  if (isIE6()) {
    autoHoverClass('article', '.articles-list');
    autoHoverClass('.comment', '.comments_articles');
    $('#gototop').data('originalOffset', {
      top: $(window).height() - $('#gototop').height() - 15,
      left: $(window).width() - $('#gototop').width() - 15
    });
  }
  $('#gototop').click(function () {
    $.scrollTo(0, 500);
    return false;
  });
  $(window).scroll(function () {
    $('#gototop').css('opacity', ($(document).scrollTop() - 150) / 100.0);
  });
});

$(function () {
  //$("a.picture img").lazyload({
  //   placeholder : "/images/white.gif",
  //   effect      : "fadeIn"
  //});
  // $('a.picture').colorbox({rel: 'group1'});
  $('body').on("click", 'a.picture', function () {
    $(this).colorbox({
      open: true
    });
    return false;
  });
  if (document.body.clientWidth >= 768) {
    $('#bs-navbar').collapse('show');
  }
});

$(function () {
  $('.poshytip').poshytip({
    className: 'tip-green',
    offsetX: -7,
    offsetY: 16,
    content: function () {
      var result = "";
      result = $(this).data("poshytiptext");
      return result;
    }
  });
});

$(function () {
  $('#select_date_for_group').change(function () {
    if ($(this).val().size === 0) {
      return false;
    }
    window.location.href = "/" + $(this).data("alias") + "/archives/" + $(this).val();
  });
  $('#select_date_for_user').change(function () {
    if ($(this).val().size === 0) {
      return false;
    }
    window.location.href = "/users/" + $(this).data("login") + "/articles/archives/" + $(this).val();
  });
});

$("body").on("change", "select#user_login", function () {
  var me = $(this);
  if (me.val() !== "") {
    show_comment_of(me, me.val());
  }
});

$(function () {
  if (typeof current_user != 'undefined') {
    $('body .my-groups').poshytip({
      className: 'tip-twitter',
      alignTo: 'target',
      alignX: 'center',
      bgImageFrameSize: 11,
      content: $('.my-groups-list')
    });
  }
});

$(function () {
  $('.article a[data-method=delete]').bind('ajax:success', function () {
    sr.article(this).slideUp(function () {
      $(this).remove();
    });
  });
  $('.comment a[data-method=delete]').bind('ajax:success', function () {
    sr.post(this).slideUp(function () {
      $(this).remove();
    });
  });
});

$(function () {
  var myDate = new Date();
  var hour = myDate.getHours();
  var slide_start = 1;
  if (hour >= 11 && hour <= 14) {
    slide_start = 2;
  }
  if (hour > 14) {
    slide_start = 3;
    if (hour > 22) {
      slide_start = 4;
    }
  }
  $("#slides").slides({
    pagination: false,
    generatePagination: false,
    generateNextPrev: false,
    play: 10000,
    slideSpeed: 600,
    start: slide_start
  });
});
$(function () {
  $('body').on('click', 'a.follow, a.unfollow', function () {
    var myself = $(this);
    $.ajax({
      type: "post",
      url: myself.attr("href"),
      dataType: "json",
      success: function (data) {
        myself.html(data.text);
        myself.attr("href", data.opposite_href);
      }
    });
    return false;
  });
});

function showAnimation(containerId, actionValue) {
  var obj = $('#' + containerId),
    pos = obj.offset(),
    ani = $('<div id="vote-ani" class="' + (actionValue > 0 ? "pos" : "neg") + '" style="font-size:10px;z-index:1000">' + (actionValue > 0 ? "+" + actionValue : "-" + actionValue) + "</div>");
  ani.appendTo('body');
  pos.top += 7;
  pos.left += 30;
  if (actionValue < 0)
    pos.left += 5;
  ani.offset(pos).css('display', 'block').animate({
    'font-size': '64px',
    opacity: 0,
    left: "-=40px"
  }, 350, 'linear', function () {
    ani.remove();
    obj.text(parseInt(obj.text()) + actionValue);
  });
}
//$(function(){
//$('.avatar').qrcode({width: 200,height: 200,text: "this plugin is great"});
//});


$(function () {
  if (!isIE6()) {
    $('.unvoted .arrow').blink().click(function () {
      $(this).blink('stop');
    });
  }
});

$(function () {
  $('body').on('click', '.need-login', function () {
    sr.showLogin();
    return false;
  });
});
$(function () {
  $('.auto-select').focus(function () {
    $(this).select();
  });
  $(".auto-select").mouseup(function (e) {
    e.preventDefault();
  });
});
$(function () {

  var Date1 = new Date();
  var Date2 = new Date("00:00:00 1/23/2012");
  var gotime = Date2.getTime() - Date1.getTime();
  if (gotime > 0) {
    $("#new-year-countdown").show();
    var seconds = parseInt(gotime / 1000);
    $('#defaultCountdown').countdown({
      until: seconds,
      format: 'DHMS',
      layout: '<div id="t7_timer">' + '<div id="t7_vals">' + '<div id="t7_d" class="t7_numbs">{dnnn}</div>' + '<div id="t7_h" class="t7_numbs">{hnn}</div>' + '<div id="t7_m" class="t7_numbs">{mnn}</div>' + '<div id="t7_s" class="t7_numbs">{snn}</div>' + '</div>' + '<div id="t7_labels">' + '<div id="t7_dl" class="t7_labs">days</div>' + '<div id="t7_hl" class="t7_labs">hours</div>' + '<div id="t7_ml" class="t7_labs">mins</div>' + '<div id="t7_sl" class="t7_labs">secs</div>' + '</div>' + '</div>'
    });
  }
});

$(function () {
  $('.subheader').hover(function () {
    $(this).toggleClass('hover');
  });
});

$(function () {
  $(".article").hover(function () {
    $(this).find(".midcol:first").toggleClass('hover');
  });
  $(".comments").on("mouseenter mouseleave", "li.comment", function () {
    $(this).toggleClass('hover');
  });
  $(".groups-list").on('mouseenter mouseleave', '.grouplist .groupitem', function () {
    $(this).toggleClass('hover');
  });
});

$(function () {
  $(".publish-article").click(function () {
    var A = $(this);
    $.ajax({
      type: "get",
      dataType: "json",
      url: A.attr('href'),
      success: function (data) {
        if (data.status == "publish") {
          A.parents(".article:first").remove();
        }
      }
    });
    return false;
  });
  $(".move-out-article").click(function () {
    var A = $(this);
    $.ajax({
      type: "get",
      dataType: "json",
      url: A.attr('href'),
      success: function () {
        A.parents(".article:first").remove();
      }
    });
    return false;
  });

  $(".tags dd").click(function () {
    var textval = $(this).text();
    var prev_text = $.trim($("#tag").val());
    prev_text.replace(/，/, ",");
    if (prev_text.split(",").length < 5) {
      if (prev_text.length > 0) {
        $("#tag").val(prev_text + "," + $.trim(textval));
      } else {
        $("#tag").val($.trim(textval));
      }
    }
  });
});
/*
$(function () {
  if (typeof current_user != 'undefined') {
    $.getJSON('/users/' + current_user.login + '/followings.json').done(function (data) {
      $('textarea').atwho("@", {
        data: data,
        tpl: "<li data-value='${login}'>${name} @${login} </li>"
      });
      $(document).bind('comments_loaded', function (event) {
        $(event.target).find('textarea').atwho("@", {
          data: data,
          tpl: "<li data-value='${login}'>${name} @${login} </li>"
        });
      });
    });
  }
});
*/

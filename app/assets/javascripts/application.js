// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery.remotipart
//= require "plugins"
//= require "sr"
//= require 'version'
//= require "old_comment"
//= require "legacy/vote"
//= require "video"
//= require "usercard"
//= require "ajaxlogin"
//= require 'group'
//= require 'salary'
//= require 'notification'
//= require 'poll'
//= require 'post'
//= require 'jquery/jquery.url'
//= require simditor
//= require simditor-dropzone
//= require to-markdown
//= require editor
//= require timeago
//= require locales/timeago.zh-cn.js
//= require bootstrap-sprockets
//= require turbolinks
//= require turbolinks.redirect
//= require nprogress
//= require nprogress-turbolinks
//= require x-editable/dist/bootstrap3-editable/js/bootstrap-editable

$.fn.editable.defaults.mode = 'inline';
$.fn.editable.defaults.ajaxOptions = {type: "PUT"};
$(function() {
  $('.relativetime').timeago();
});


if (soundManager) {
  soundManager.url = '/';
  soundManager.preferFlash = false;
}

$(document).on("click", 'a.picture', function () {
  $(this).colorbox({
    open: true
  });
  return false;
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
    window.location.href = "/users/" + $(this).data("login") + "/topics/archives/" + $(this).val();
  });
  if (document.body.clientWidth >= 768) {
    $('#bs-navbar').collapse('show');
  }
});

$(document).on("change", "select#user_login", function () {
  var me = $(this);
  if (me.val() !== "") {
    show_comment_of(me, me.val());
  }
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


$(document).on('click', '.need-login', function () {
  sr.showLogin();
  return false;
});

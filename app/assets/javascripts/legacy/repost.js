//= require "sr"
//= require 'plugins'
// require "jquery.mustache"
// require "jquery.qtip"

$(function(){
  function repost(){
    var el = $(this), tip = el.parents('.qtip'), post_id = tip.data('post_id'), api = tip.qtip('api');

    $.post('/posts/'+post_id+'/repost', {group_id: $(this).data('group_id')}, function(){
      el.hide();
      api.hide();
    });
  }

  if(!current_user){
    return;
  }

  var tmp = $.mustache("<div class='repost_form'>{{#groups}}\
  <a href='javascript:void(0)' id='repost_to_group_{{id}}' class='repost_to_group' data-group_id={{id}}>{{name}}</a>\
  {{/groups}}{{^groups}}您还未加入任何小组，请去<a href='/groups'>参观</a>一下吧!{{/groups}}</div>", current_user);

  $('.repost_button').poshytip({
    id: 'repost_tip',
    content: {
      text: tmp,
      title: {
                text: 'Repost to which group?',
                button: true
             }
    },
    show: {
      event: 'click',
      solo: true
    },
    hide: {
      event: 'close'
    },
    events: {
      show: function(event, api){
        var t = api.elements.target, tip = api.elements.tooltip;
        var topic = sr.topic(t);
        var post = topic.contents('.post:first');
        tip.data('post_id', sr.id(post));
        $('.repost_to_group', tip).click(repost);
        $('.reposted_to', post).each(function(){
          var gid = $(this).data('group_id');

          $('#repost_to_group_'+gid, tip).hide();
        });
      }
    }
  });
});

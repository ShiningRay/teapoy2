function fullscreen(id){
  var e = $('#'+id);
  var original_width = e.width(), original_height = e.height();
  $.colorbox({
    inline: true,
    href: '#'+id,
    width: '99%', height: '100%', fixed: true,
    onComplete: function(){
      e.width('100%');
      e.height('100%');
    },
    onClosed: function(){
                e.width(original_width);
                e.height(original_height);
              }
  })
}
$(function(){
  $('.article').on('click', '.flash_link a', function(){
    var e = $(this),
        p = e.parent();
    p.hide();
    p.next('.close_flash').show();
    swfobject.embedSWF(
      e.data('flash'),
      "video-"+e.data('id'),
      '550', '410', '9.0.0', null,
      { 'isAutoPlay': true,
        'playMovie': true,
        'auto': 1,
        'autostart': true
      }, {wmode: 'transparent'});
      e.parent().parent().addClass("video-on");
    return false;
  }).on('click', '.flash_link .overlay', function(){
    $(this).prev('a').click();
  }).on('click', '.close_flash', function(){
    var post = sr.post(this),
        video_id = sr.id(post),
        myself = $(this);
    myself.hide()
    //remove掉视频flash
    $('#video-'+video_id).remove();
    //显示视频缩略图
    post.find('.flash_link').show();
    //隐藏收起链接
    post.find('.entry-content').removeClass("video-on");
    $("<div id='video-"+video_id+"'></div>").insertBefore(post.find("p"));
    return false;
  });
 $('.flash_container').each(function(){
    var url = $(this).data('url');
    swfobject.embedSWF(url, $(this).attr('id'), 550, 440, '9.0.0', null, {allowscriptaccess: 'sameDoamin', allowfullscreen: true});
  });

});

// add video overlay to video picture

$(window).load(function(){
  $('.external_video .flash_link').each(function(){
    $(this).append("<img src='/images/videoplay.gif' alt='' class='overlay'/>")
  });

})
$(document).ready(function() {
  $('.thumb_img_link').on('error', function(){
    $(this).attr("src","/images/playvideo.jpg");
  });
});

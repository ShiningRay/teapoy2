/**
 *= require highcharts/highcharts
 */
function select_item(sel) {
    $("input:checkbox").each(function(){
      this.checked = sel(this.checked);
    })
}

function select_all(){select_item(function(){return true});}
function select_none(){select_item(function(){return false});}
function select_reverse(){select_item(function(i){return !i});}

function set_status(id, status){
    $('#status').load('/admin/set_status/' + id + '?status=' + status)
}


function load_comments(el, id){
    var entry=$(el).parents('.entry');
    var ul = entry.children('ul.list');
    if(ul.size() == 0){
      ul = $("<ul class='list'/>").appendTo(entry);
    }
    ul.load('/admin/topics/comments/'+id);
}

$(function(){
   $(".status-edit a").click(function(){
       var self = $(this);
       $.post(this.href, function(){
         self.parents('.entry').remove();
       });
       return false;
   })
    $(".report-edit a").click(function(){
       var self = $(this);
       $.get(this.href, function(){
         self.parents('.entry').remove();
       });
       return false;
   })
   $('.comment-manage a').live('click', function(){
       var self = $(this);
       $.get(this.href, function(){
            self.parents('.comment').remove();
       });
       return false;
    });

    $(".track").click(function(){
     $.get(this.href,function(text){
         alert(text)
       $(this).parent().find("#trackinfo").html(text);
    });
       return false;
    });
    /*
    $('#reply_dialog').dialog({
        bgiframe: true,
        autoOpen: false,
        height: 300,
        modal: true,
        buttons: {
            'Reply': function() {
                var bValid = true;
                //allFields.removeClass('ui-state-error');

                if (bValid) {
                    $('#reply_form').submit();
                    //$(this).dialog('close');
                }
            },
            Cancel: function() {
                $(this).dialog('close');
            }
        },
        close: function() {
            //allFields.val('').removeClass('ui-state-error');
        }

    });*/

});

function opendialog(url){
    $('#dialog').dialog('open');
    $('#dialog').load(url);
}

function deleteelse(form){
    if(form.delete_else.checked){
        form.delete_else.value = '';
        $("input.entry-id").each(function(){
            if(!this.checked){
                form.delete_else.value += this.value + ',';
            }
        });
        //console.debug(form.delete_else.value);
    }
    return true;
}


$(function(){
  $('.group-list').scrollTo($('.group-list .current'));
})

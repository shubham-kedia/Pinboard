// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs

//= require jquery.ui.all

//= require twitter/bootstrap
//= require_tree .

function sync_notices()
{
    $.ajax({
      url: "/notices/load_notices/",
      type: "post",
      dataType: "json",
      data: {},   // for query string
      success: function(data)
                {

                    if (data.status == 1)
                    {
                      //create the template
                        var t = _.template($('#notice_template').html());

                        //empty the board
                        $("#board_private ul").empty();



                        $.each(data.private_notice, function(index, element) {
                          load_notice(data.user_name,element,'private',t)
                        });

                        //empty the board
                        $("#board_public ul").empty();

                        $.each(data.public_notice, function(index, element) {
                          load_notice(data.user_name,element,'public',t)
                          // load public
                        });

                    }
                    else
                        alert("Some Error during Sync");
                }
        });
}

function load_notice(username,data,type,template)
{
    if(data)
    {
      //use template or create one
      var t = template ||  _.template($('#notice_template').html());

      //set data need for tmeplate
      data.type=type;
      data.className = 'context-menu-note-' + type;

      if(username == data.author)
      {
          data.user_color=data.user_color;
          data.className += '-own';
      }

      //render template
      $("#board_"+ type +" ul").append(t({element:data}));
    }

}

$(function(){
    $.contextMenu({
        selector: '.context-menu-board',
        callback: context_menu_callback ,
        items: {
            "new": {name: "New note",icon: "add"},
              "sep1": "---------",
            "search": {name: "Search by keyword",icon: "searchbykey"},
              "sep2": "---------",
            "settings": {name: "Settings", icon: "settings"}

        }
    });

    $(document).on('dblclick','.notice',function(e){
        e.preventDefault();
        var obj ={
          id:  $(this).attr('id'),
          content: $(this).find('.notice_content').html(),
          title: $(this).find('.notice_title').html(),
          type: $(this).attr('access_type')
        }

        show_notice_modal(obj);

    });

$.contextMenu({
        selector: '.context-menu-note-private',
        callback: context_menu_callback ,
        items: {
            "make_public": {name: "Share with your team", icon: "share_team"},
             "sep1": "---------",
            "mail": {name: "Send by e-mail", icon: "mail"},
             "sep2": "---------",
            "edit": {name: "Edit", icon: "edit_notice"},
             "sep3": "---------",
            "delete": {name: "Delete", icon: "delete"}

        }
    });

$.contextMenu({
        selector: '.context-menu-note-public',
        callback: context_menu_callback ,
        items: {

            "mail": {name: "Send by e-mail", icon: "mail"},
             "sep2": "---------",
            "edit": {name: "Edit", icon: "edit_notice"},
             "sep3": "---------",
            "delete": {name: "Delete", icon: "delete"}

        }
    });

$.contextMenu({
        selector: '.context-menu-note-public-own',
        callback: context_menu_callback ,
        items: {
            "make_private": {name: "Make private", icon: "make_private"},
             "sep1": "---------",
            "mail": {name: "Send by e-mail", icon: "mail"},
             "sep2": "---------",
            "edit": {name: "Edit", icon: "edit_notice"},
             "sep3": "---------",
            "delete": {name: "Delete", icon: "delete"}

        }
    });



});


function contextMenuAction(key,id,obj)
{
   switch(key){
      case 'new': show_notice_modal();
                  break;
      case 'edit': show_notice_modal(obj);
                   break;
      case 'search': (function(){
                      if (id == 'board_public'){
                        $("#search_board").val('public');
                      }else{
                        $("#search_board").val('private');
                      }
                      $("#search_modal").modal('show');
                    })();
                    break;
      case 'settings': $("#setting_modal").modal('show');
                      break;
      case 'mail': (function(){
                      $("#mail_noteid").val(id);
                      $("#email_modal").modal('show');
                  })();
                  break;
      case 'make_public':
                    $.ajax({
                      url: "/notices/makepublic/" + id,
                      type: "post",
                      dataType: "json",
                      data: {},   // for query string
                      success: function(data)
                                {
                                    if (data.status == 1)
                                        sync_notices();
                                    else
                                        alert("error during share with team");
                                }
                        });
                  break;

      case 'make_private':
                    $.ajax({
                      url: "/notices/makeprivate/" + id,
                      type: "post",
                      dataType: "json",
                      data: {},   // for query string
                      success: function(data)
                                {
                                    if (data.status == 1)
                                        sync_notices();
                                    else
                                        alert("error during make Private");
                                }
                        });
                  break;

      case 'mail': alert("mail");
                  break;

      case 'delete':
                    $.ajax({
                      url: "/notices/" + id,
                      type: "post",
                      dataType: "json",
                      method:'delete',
                      data: {},   // for query string
                      success: function(data)
                                {
                                    if (data.status != 1){
                                     alert("error during delete");
                                    }
                                }
                        });
                  break;
   }
}

show_notice_modal = function(obj){
  //if empty show empty form
  var form = $("#new_notice");
  if (obj == null || typeof(obj) == 'undefined'){
      $("#notice_title").val('');
      $("#notice_access_type").val('private');
      $("#notice_content").val('');
      form.attr({'action': window.new_notice_url });
      form.find('input[name="_method"]').remove();
      form.find('input[type="submit"]').val('Create Notice');
      $("#myModal_new").modal('show');
      $("#myModalLabel").text('Create Notice');

  }else{
      $("#notice_title").val(obj.title);
      $("#notice_access_type").val(obj.type);
      $("#notice_content").val(obj.content);
      form.attr({'action': window.edit_notice_url + '/' + obj.id });
      form.find('input[type="submit"]').val('Update Notice');
      form.find('input[name="_method"]').remove();
      form.append('<input name="_method" type="hidden" value="put" />')
      $("#myModalLabel").text('Edit Notice');
      $("#myModal_new").modal('show');
  }
  return true;
}

context_menu_callback  =function(key, options) {
            var id =  options.$trigger.attr('id');
            // alert("Clicked on " + key + " on element " + options.$trigger.attr('id'));

            //for edit modal
            var obj = {}
            if (options.$trigger.hasClass('notice')){
              obj ={
                id: options.$trigger.attr('id'),
                content:options.$trigger.find('.notice_content').html(),
                title:options.$trigger.find('.notice_title').html(),
                type:options.$trigger.attr('access_type')
              }
            }

            contextMenuAction(key,id,obj);
            // window.console && console.log(m) || alert(m);
}
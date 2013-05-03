// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

function loadnotices()
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
                        $("#board_private ul").empty();
                        var t = _.template($('#notice_template').html());
                        $.each(data.private_notice, function(index, element) {
                            element.className = 'context-menu-note-private';
                            element.type="private";
                            element.user_color=data.user_color;
                            $("#board_private ul").append(t({element:element}));
                        });
                        $("#board_public ul").empty();
                        var t = _.template($('#notice_template').html());
                        $.each(data.public_notice, function(index, element) {
                            if(data.user_name == element.author)
                            {
                                element.user_color=data.user_color;
                                element.className = 'context-menu-note-public-own';
                            }
                            else
                            {
                                element.className = 'context-menu-note-public';
                            }
                            element.type="public";
                            $("#board_public ul").append(t({element:element}));
                        });

                       /*
                        var listedItems="";
                       $.each(data.private_notices, function(index, element) {
                            listedItems += "<li class='context-menu-note-private' id='"+element.id+"'>";
                            listedItems += "<a href='#'><img src='assets/pin.png' class='sticky_pin'>";
                            listedItems += "<h4>"+element.title+"</h4><p>"+element.content+"</p></a></li>"
                        });
                        $("#board_private ul").append(listedItems);*/
                        // window.location.reload();
                    }
                    else
                        alert("error during make Private");
                }
        });
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
          content: $(this).find('.notice_title').html(),
          title: $(this).find('.notice_content').html(),
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
      case 'search': alert("search");
                  break;
      case 'settings': alert("settings");
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
                                        window.location.reload();
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
                                        window.location.reload();
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
                                    if (data.status == 1)
                                        window.location.reload();
                                    else
                                        alert("error during delete");
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
                content:options.$trigger.find('.notice_title').html(),
                title:options.$trigger.find('.notice_content').html(),
                type:options.$trigger.attr('access_type')
              }
            }

            contextMenuAction(key,id,obj);
            // window.console && console.log(m) || alert(m);
}
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


$(function(){
    $.ajax({
      url: "/notices/load_notices/",
      type: "post",
      dataType: "json",
      data: {},   // for query string
      success: function(data)
                {
                   /* if (data.status == 1)
                        window.location.reload();
                    else
                        alert("error during make Private");*/
                }
        });  
});
$(function(){
    $.contextMenu({
        selector: '.context-menu-board', 
        callback: function(key, options) {
            var id =  options.$trigger.attr('id');
            // alert("Clicked on " + key + " on element " + options.$trigger.attr('id'));
            contextMenuAction(key,id);
            // window.console && console.log(m) || alert(m); 
        },
        items: {
            "new": {name: "New note",icon: "add"},
              "sep1": "---------",
            "search": {name: "Search by keyword",icon: "searchbykey"},
              "sep2": "---------",
            "settings": {name: "Settings", icon: "settings"}

        }
    });
    
$.contextMenu({
        selector: '.context-menu-note-private', 
        callback: function(key, options) {
            var id =  options.$trigger.attr('id');
            // alert("Clicked on " + key + " on element " + options.$trigger.attr('id'));
            contextMenuAction(key,id);
            // window.console && console.log(m) || alert(m); 
        },
        items: {
            "make_public": {name: "Share with your team", icon: "share_team"},
             "sep1": "---------",
            "mail": {name: "Send by e-mail", icon: "mail"},
             "sep2": "---------",
            "edit": {name: "Edit", icon: "edit_note"},
             "sep3": "---------",
            "delete": {name: "Delete", icon: "delete"}

        }
    });

$.contextMenu({
        selector: '.context-menu-note-public', 
        callback: function(key, options) {
            var id =  options.$trigger.attr('id');
            // alert("Clicked on " + key + " on element " + options.$trigger.attr('id'));
            contextMenuAction(key,id);
            // window.console && console.log(m) || alert(m); 
        },
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
        callback: function(key, options) {
            var id =  options.$trigger.attr('id');
            // alert("Clicked on " + key + " on element " + options.$trigger.attr('id'));
            contextMenuAction(key,id);
            // window.console && console.log(m) || alert(m); 
        },
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


// $(function () {
//     var $modal = $('#modal');
//     $('#clicker').on('click', function (e) { /** Call the modal manually */
//         alert();
//         // e.preventDefault();
//         var url = $(this).attr('href');
//         $modal.html('<iframe width="100%" height="100%" frameborder="0" scrolling="no" allowtransparency="true" src="' + url + '"></iframe>');
//         $modal.modal({
//             show: true
//         });
//     });


//     $modal.on('hide', function () {
//         $modal.empty() /** Clean up */
//     });
// });


function contextMenuAction(key,id)
{
   switch(key){
      case 'new': $("#new_modal_link").trigger('click');
                  break;
      case 'search': alert("search");
                  break;
      case 'settings': alert("settings");
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
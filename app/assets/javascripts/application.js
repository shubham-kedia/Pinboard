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
        selector: '.context-menu-note', 
        callback: function(key, options) {
            var id =  options.$trigger.attr('id');
            // alert("Clicked on " + key + " on element " + options.$trigger.attr('id'));
            contextMenuAction(key,id);
            // window.console && console.log(m) || alert(m); 
        },
        items: {
            "share": {name: "Share with your team", icon: "shareteam"},
             "sep1": "---------",
            "mail": {name: "Send by e-mail", icon: "mail"},
             "sep2": "---------",
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
      case 'share': alert("share");
                  break;
      case 'mail': alert("mail");
                  break;
      case 'delete': alert(id);
                    $.ajax({
                      url: "/notices/" + id,
                      type: "post",
                      dataType: "json",
                      method:'delete',
                      data: {},   // for query string
                      success: function(data){
                        if (data.status == 1){
                            alert("deleted");
                            window.location.reload();
                        }else{
                             alert("not deleted");
                        }
                      }
                    });        
                    alert(id);
                  break;
   }
}
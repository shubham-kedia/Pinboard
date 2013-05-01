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
            var m = "clicked: " + key;
            window.console && console.log(m) || alert(m); 
        },
        items: {
            "new": {name: "New note",icon: "add"},
              "sep1": "---------",
            "cut": {name: "Search by keyword", icon: "cut"},
              "sep2": "---------",
            "copy": {name: "Settings", icon: "copy"}

        }
    });
    
$.contextMenu({
        selector: '.context-menu-note', 
        callback: function(key, options) {
            var m = "clicked: " + key;
            window.console && console.log(m) || alert(m); 
        },
        items: {
            "share": {name: "Share with your team", icon: "add"},
             "sep1": "---------",
            "mail": {name: "Send by e-mail", icon: "copy"},
             "sep2": "---------",
            "delete": {name: "Delete", icon: "delete"}

        }
    });


    $('.context-menu-one').on('click', function(e){
        console.log('clicked', this);
    })
});
// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//

//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require jquery.remotipart
//= require jquery.iframe-transport
//= require twitter/bootstrap
//= require_tree .

$(document).ready(function(){
   window.notice=function(header,body){
      $('#notice_header').html(header);
      $('#notice_body').html(body);
      $('#notice').modal("show");
    }

    // $(document).on("click",".notice_list",function() {
    //   $(this).siblings().css("z-index","0");
    //   $(this).css("z-index","1");
    // });
// modal comment show
  $(document).on("click",".add_comment_icon",function(){
        var form = $("#new_comment");
        // $("#comment_user_id").val('1');
        $("#comment_notice_id").val($(this).closest("li").attr("id"));
        $("#comment_comment").val('');
        form.attr({'action': window.new_comment_url });
        form.find('input[name="_method"]').remove();
        form.find('input[type="submit"]').val('Add Comment');
        $("#myModal_comment").modal('show');
        $("#myModalLabel").text('Add Comment');
  });

//    show hide image popup
    $(document).on("mouseover",".img_icon",function(){
        var not_ele = $(this).closest(".notice");
        $(".images_popup").hide();
        not_ele.find(".images_popup").show();
    });
    $(document).on("mouseover",".images_popup",function(){
        $(this).show();
    });
    $(document).on("mouseout",".images_popup",function(){
        $(".images_popup").hide();
    });
     $(document).on("mouseout",".img_icon",function(){
        $(".images_popup").hide();
    });

//    show hide comment popup
    $(document).on("mouseover",".comment_icon",function(){
        var not_ele = $(this).closest(".notice");
        $(".comments_popup").hide();
        not_ele.find(".comments_popup").show();
    });
    $(document).on("mouseover",".comments_popup",function(){
        $(this).show();
    });
    $(document).on("mouseout",".comments_popup",function(){
        $(".comments_popup").hide();
    });
     $(document).on("mouseout",".comment_icon",function(){
        $(".comments_popup").hide();
    });


    $("#new_notice").bind("ajax:complete", function(){
      $("#myModal_new").modal("hide");
      var file_input =  $("#notice_img");
      file_input.replaceWith(file_input = file_input.clone( true ));
      sync_notices();
    });

// close the modal popup when click cancel button
    $(document).on("click","#cancel_search",function() {
            $("#search_modal").modal('hide');
            // $(".refresh_notices").show();
    });

    $(document).on("click","#refresh_notices",function() {
            $("#email_modal").modal('hide');
    });

    $(document).on("click",".refresh_notices",function() {
            sync_notices();
            $(".refresh_notices").hide();
    });
    
// delete images and comments
    $(document).on("click",".This_comment",function() {
            var id = $(this).attr("id");
            // alert(id);
            $.ajax({
                      url: "/comments/" + id,
                      type: "post",
                      dataType: "json",
                      method:'delete',
                      data: {},   // for query string
                      success: function(data)
                                {
                                    if (data.status != 1){
                                     alert("error during delete");
                                    }
                                     sync_notices();
                                }
                        });
    });

     $(document).on("click",".This_image",function() {
            var id = $(this).attr("id");
            // alert(id);
            $.ajax({
                      url: "/notices/deleteImage/" + id,
                      type: "post",
                      dataType: "json",
                      data: {},   // for query string
                      success: function(data)
                                {
                                    if (data.status != 1){
                                     alert("error during delete");
                                    }
                                     sync_notices();
                                }
                        });
    });


var user_id_notices=0,first="yes",marginTop=0,marginLeft=0,column=0;
window.sync_notices = function()
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

                      //empty the board private
                      $("#board_private ul").empty();

                      $.each(data.private_notice, function(index, element) {
                        just_text=load_notice(data.user_id,element,'private',t,'');
                      });

                      load_public_notices(data,t,"yes");


                    }
                    else
                        alert("Some Error during Sync");
                }
        });
}
sync_notices();

var i=0;
window.load_public_notices = function (data,t,from_sync)
{
  var notice_array=null;
  if(from_sync=="yes")
    notice_array=data.public_notice;
  else
    notice_array=data.notices;

    //empty the board public
  $("#board_public").empty();

  var total_string = '<div class="row">';

    user_id_notices=0;
    first="yes";
    marginTop=0;
    marginLeft=0;
    column=0;
    $.each(notice_array, function(index, element) {

      marginTop+=30;
      marginLeft+=25;
      if(user_id_notices!=element.user_id)
      {

        user_id_notices=element.user_id;
        var evens = _.countBy(notice_array, function(ele){ return ele.user_id == user_id_notices ? 'this_user_count' : 'other_user_count'; });
        current_user_notices=evens.this_user_count;
        // alert((data.public_notice).length);
        height=(current_user_notices * 30)+200;

        if(first=="yes") 
          first="no";
        else
          total_string +='</ul></div>';

        if(column%3==0) 
          total_string +='</div><div class="row">';

        column =column+1
        total_string += '<div class="span3" style="height:'+height+'px">';
        total_string +='<ul class="inner_list">';
        marginTop = 0;
        marginLeft = 0;
      }
      // set margin to notice
      set_margin="margin-left:"+marginLeft+"px;margin-top:"+marginTop+"px;";
      total_string +=load_notice(data.user_id,element,'public',t,set_margin);
       // load public
    });

  total_string +='</ul>';
  total_string +='</div>';
  total_string += '</div>';
  $("#board_public").html(total_string);
}
window.load_notice = function (userid,data,type,template,set_margin)
{
  // alert();
    if(data)
    {
      //use template or create one
      var t = template ||  _.template($('#notice_template').html());

      //set data need for tmeplate
      data.type=type;
      data.set_margin=set_margin;
      data.className = 'context-menu-note-' + type;
      data.z_index=i;
      data.images_popup = "";  
      data.img_count="";
      data.hidden_class_img="hide";

      data.comments_popup = "";  
      data.comment_count="";
      data.hidden_class_comment="hide";

      if (data.images){
        data.img_count = (data.images.length>0) ? "("+data.images.length+")" : "";
        data.hidden_class_img = (data.images.length>0) ? "" : "hide";
        for(j=0;j<data.images.length;j++)
        {
          data.images_popup += '<div class="image_list"><a class="This_image" id="'+data.images[j].img_id+'">x</a><img src="'+data.images[j].img_path+'"></div>';
        }
      }
      if (data.comments){
        data.comment_count = (data.comments.length>0) ? "("+data.comments.length+")" : "";
        data.hidden_class_comment = (data.comments.length>0) ? "" : "hide";
        for(j=0;j<data.comments.length;j++)
        {
          data.comments_popup += '<div><h5>'+data.comments[j].user_name+': </h5><p>'+data.comments[j].comment+' <a id="'+data.comments[j].comment_id+'" class="This_comment">Remove</a></p></div>';
        }
      }
      data.notice_color=data.user_color;
      data.text_color=inverseColor(data.user_color);
      if(userid == data.user_id)
      {
          data.className += '-own';
      }

      //render template
      if(type=='private')
        $("#board_"+ type +" ul").append(t({element:data}));
      else
        return t({element:data});
      return "";
    }

}

function inverseColor(theString)
{
    var theString = theString.substring(4,theString.length-1);
  var numbers = theString.split(',');
  a= parseInt(numbers[0]);
  b= parseInt(numbers[1]);
  c= parseInt(numbers[2]);

  return ((0.2126 *a) + (0.7152 * b) + (0.0722 * c)) >= 165 ? 'black' : 'white';
  newColor='#'+DecToHex(255-a)+""+DecToHex(255-b)+""+DecToHex(255-c);
  return newColor;
}
var hexbase="0123456789ABCDEF";
function DecToHex(number) 
{
  return hexbase.charAt((number>> 4)& 0xf)+ hexbase.charAt(number& 0xf);
}




$(function(){
    $.contextMenu({
        selector: '.context-menu-board',
        callback: context_menu_callback ,
        items: {
            "sep1": "---------",
            "new": {name: "New note",icon: "add"},
              "sep2": "---------",
            "search": {name: "Search by keyword",icon: "searchbykey"},
              "sep3": "---------",
            "settings": {name: "Settings", icon: "settings"}

        }
    });

    $(document).on('dblclick','.obj_class',function(e){
        e.preventDefault();
        var obj ={
          id:  $(this).attr('id'),
          content: $(this).find('.notice_content').html().replace(/<br>/g , '\n'),
          title: $(this).find('.notice_title').html().replace(/<br>/g , '\n'),
          type: $(this).attr('access_type')
        }

        show_notice_modal(obj);

    });

$.contextMenu({
        selector: '.context-menu-note-private-own',
        callback: context_menu_callback ,
        items: {
            "sep1": "---------",
            "make_public": {name: "Share with your team", icon: "share_team"},
             "sep2": "---------",
            "mail": {name: "Send by e-mail", icon: "mail"},
             "sep3": "---------",
            "edit": {name: "Edit", icon: "edit_notice"},
             "sep4": "---------",
            "delete": {name: "Delete", icon: "delete"}

        }
    });

$.contextMenu({
        selector: '.context-menu-note-public',
        callback: context_menu_callback ,
        items: {
            "sep1": "---------",
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
            "sep1": "---------",
            "make_private": {name: "Make private", icon: "make_private"},
             "sep2": "---------",
            "mail": {name: "Send by e-mail", icon: "mail"},
             "sep3": "---------",
            "edit": {name: "Edit", icon: "edit_notice"},
             "sep4": "---------",
            "delete": {name: "Delete", icon: "delete"}

        }
    });

   $("#myModal_new").on ('show',function(){
    $("#notice_content").trigger('keydown');
   });

});


function contextMenuAction(key,id,obj)
{
   switch(key){
      case 'new': //$(".file_row").show();
                  show_notice_modal();
                   // $(".file_row").hide();
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
                                     sync_notices();
                                }
                        });
                  break;
   }
}

show_notice_modal = function(obj){
  // console.log(obj);
  //if empty show empty form
  var form = $("#new_notice");
  if (obj == null || typeof(obj) == 'undefined'){
      $("#notice_title").val('');
      $("#notice_access_type").val('private');
      $("#notice_content").val('');
      // $(".file_row td").show();
      form.attr({'action': window.new_notice_url });
      form.find('input[name="_method"]').remove();
      form.find('input[type="submit"]').val('Create Notice');
      $("#myModal_new").modal('show');
      $("#myModalLabel").text('Create Notice');

  }else{
      $("#notice_title").val(obj.title);
      $("#notice_access_type").val(obj.type);
      $("#notice_content").val(obj.content);
      // $(".file_row").hide();
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
            if (options.$trigger.hasClass('obj_class')){
              obj ={
                id: options.$trigger.attr('id'),
                content:options.$trigger.find('.notice_content').html().replace(/<br>/g , '\n'),
                title:options.$trigger.find('.notice_title').html().replace(/<br>/g , '\n'),
                type:options.$trigger.attr('type')
              }
            }
            contextMenuAction(key,id,obj);
            // window.console && console.log(m) || alert(m);
}

});
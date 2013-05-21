# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
	# for modal change access type for private or public
	$("#myModal_new").on 'shown', ->
		if $("#private_tab").hasClass 'active'
			$("#myModal_new #notice_access_type").val 'private';
		else
			$("#myModal_new #notice_access_type").val 'public';
		return

	$("#notice_content").on 'keydown', (e) ->
		$("#char_left").text( 256 - $(this).val().length + ' Char left')
		if $(this).val().length > 255
			$(this).val($(this).val().substring(0,255))
			e.preventDefault
			return false
		true

	$("#send_email_btn").click ->
		if($("#send_by_email").valid())
			$("#send_email_btn").val("Sending Email..")
			$.ajax '/notice/send_by_mail',
				type:'post',
				data:{id:$("#mail_noteid").val(),email:$("#email_send").val()},
				dataType:'json'
				success:(data) ->
					$("#send_email_btn").val("Send Mail")
					if data.status == 1
						$("#email_modal").modal('hide')
						notice("Mail ", "Mail successfully sent")
					else
						$("#email_modal").modal('hide')
						notice("Mail", "Sending Failed , Try again")
				error:()->
					$("#send_email_btn").val("Send Mail")
					$("#email_modal").modal('hide')
					notice("Mail", "Sending Failed , Try again")
		false

	$("#search_btn").click ->
		if($("#search_by_keyword").valid())
            $(".refresh_notices").show()
			search_type = $("#search_board").val() 
			$.ajax
				url: '/notice/search/' + search_type + '/' + $('#search_keyword').val()
				type:'get'
				dataType:'json'
				success: (data) ->
					if data.status == 1
						$("#search_modal").modal('hide');
						t = _.template($('#notice_template').html())
						if search_type == 'private'
							$("#board_"+search_type+" ul").empty();
							$.each data.notices, (index, element) ->
								load_notice(data.user_id,element,search_type ,t,'')
								return
						else
							load_public_notices(data,t,"no")
							return
					else
						alert('Error Occured. Try again')
						return
				error:()->
					alert('error')
					true
		false
		
	$("#send_by_email").validate
		rules:
			"email-send":
				email: true
				required: true

		messages:
			"email-send":
				email: "Invalid Email"
				required: "Enter Your Email-ID"

		highlight: (label) ->
			$(label).closest(".control-group").addClass "error"
	$("#search_by_keyword").validate
		rules:
			"search_keyword":
				required:true
		highlight: (label) ->
			$(label).closest(".control-group").addClass "error"
	return

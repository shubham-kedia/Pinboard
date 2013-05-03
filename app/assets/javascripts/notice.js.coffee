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
		$.ajax '/notice/send_by_mail',
			type:'post',
			data:{id:$("#mail_noteid").val(),email:$("#email_send").val()},
			success:(data) ->
				if data.status == 1
					alert('Mail Sent')
					$("#email_modal").modal('hide')
				else
					alert('Error Occured. Try again')
			error:()->
				alert('error')
	return

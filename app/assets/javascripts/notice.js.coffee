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
	return
$("document").ready ->
	$("#login_box").dialog
		autoOpen: false
		draggable: false
		title: "Login"
		width: 450
		resizable: false
		modal: true
	$(".login_error_msg").html ""
	$("#login_box_left_login form").on "submit", ->
		form = $(this);
		if $(this).valid()
			$(form).find("input[type='submit']").val("Logging in..");
			$.ajax
				url: "/users/sign_in"
				type: "post"
				dataType :"json"
				data: $("#login_box_left_login form").serialize()
				success: (data) ->
					if(data.status == true)
						window.location.href= "/notices"
					else
						console.log(data.text)
						$(form).find("input[type='submit']").val("Login");
						$(".login_error_msg").html(data.text);
						false
				error: (xhr,status,str) ->
					console.log(xhr.responseText.text)
					$(form).find("input[type='submit']").val("Login")
					$(".login_error_msg").html(xhr.responseText.text)
					false
			false
		false
	$(".devise_pages .validate_reg").on "submit", ->
		form = $(this)
		if $(this).valid()
			$(this).find("input[name='commit']").val("Signing Up...")
			$.ajax
				url:$(form).attr("action")
				type:"post"
				dataType:"json"
				data: $(form).serialize()
				success: (data) ->
					if data.status == true
						$(form).find("input[name='commit']").val("Sign up")
						$("#login_box").dialog( "close" )
						$("#team_name").autocomplete
							source: data.team
						option_data=""
						data_ary = []

						$.each data.team,(index,val) ->
							option_data += "<option value='"+val.id+"'>"+val.name+"</option>"
							data_ary.push(val.name)
						$("#team_name").autocomplete
							source: data_ary
						$("#team_ids").html(option_data)
						$("#team_ids").trigger("liszt:updated")
						notice("Registration Successful","You have Successfully registered to PinBoard<br>Please Login to Continue")
					else
						notice("Error in Registration","Error Occured during registration")
		false

	$(".forgot_password_form").on "submit", ->
		$("#loading_div").fadeIn().html("Sending Password instructions to your Email... ")
		$.ajax
			url: "/users/password"
			type: "post"
			data: $(".forgot_password_form").serialize()
			complete: (jqxhr, txt_status) ->
				if jqxhr.status is 200
					$(".forgot_error").html "Check the Mail For Password Instructions"
				else
					$(".forgot_error").html "Error Occured"
				$("#loading_div").fadeOut()

		false

	$(".open_login_popup").on "click", ->
		$("#login_box_left .boxes").hide()
		$("#login_box_left_login").show()

		$("#login_box").dialog('option','title',"Login")
		$(".devise_pages a[href='/users/sign_in']").hide()
		$(".devise_pages a[href='/users/sign_up']").show()
		$("#login_box").dialog "open"


	$(".open_signup_popup").on "click", ->
		$("#login_box_left .boxes").hide()
		$("#login_box_left_signup").show()
		$("#login_box").dialog('option','title',"Sign Up")
		$("#login_box").dialog "open"
		$(".devise_pages a[href='/users/sign_in']").show()
		$(".devise_pages a[href='/users/sign_up']").hide()

	$("#new_team_check").on "click", ->
		if this.checked==true
			$("#new_team").closest("div").removeClass("disabled");
			$("#new_team").removeAttr("disabled")
		else
			$("#new_team").closest("div").addClass("disabled")
			$("#new_team").attr("disabled","disabeld").val("")

	$("a[href='/users/login']").hide()
	$(".devise_pages a").click ->
		action = $(this).text()
		$("#login_box").dialog('option','title',action)
		switch(action)
			when "Login"
				$("#login_box_left .boxes").slideUp 0
				$("#login_box_left_login").slideDown 200
			when "Sign up"
				$("#login_box_left .boxes").slideUp 0
				$("#login_box_left_signup").slideDown 200
			when "Forgot your password?"
				$("#login_box_left .boxes").slideUp 0
				$("#login_box_left_password").slideDown 200
		$(".devise_pages a").css("display","none")
		$(".devise_pages a").each (ele) ->
			if $(this).text() != action
				$(this).show()
		false

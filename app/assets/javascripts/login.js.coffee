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
		$(this).find("input[name='commit']").val("Signing Up...")
		if $(this).valid()
			$.ajax
				url:$(form).attr("action")
				type:"post"
				dataType:"json"
				data: $(form).serialize()
				success: (data) ->
					if data.status == true
						$(form).find("input[name='commit']").val("Sign up")
						$("#login_box").dialog( "close" )
						console.log(data.team);
						window.availableTags = data.team
						$("#user_team").append("<option value='"+data.team_id+"'>"+data.team_name+"</option>");
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




$("document").ready ->
	$("#login_box").dialog
		autoOpen: false
		draggable: false
		title: "Login"
		width: 450
		resizable: false
		modal: true
	$(".login_error_msg").html ""
	$(".devise_pages .validate_reg").on "submit", ->
		form = $(this)
		$(this).find("input[name='commit']").val("Signing Up...")
		if $(this).valid()
			$.ajax
				url:$(form).attr("action")
				type:"post"
				data: $(form).serialize()
				complete:(jqxhr,txt_status) ->
					$(form).find("input[name='commit']").val("Sign up")
					console.log("status"+jqxhr.status)
					console.log(txt_status)
					if jqxhr.status is 200 or jqxhr.status is 401 or jqxhr.status is 302 or jqxhr.status is 304
						#$("#registration_msg").html("An email has been sent to you. Please click on the link in the email to activate your account").fadeIn(100).delay(4000).fadeOut(500,()->
						$("#login_box").dialog( "close" )
						console.log("came")
						#)
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

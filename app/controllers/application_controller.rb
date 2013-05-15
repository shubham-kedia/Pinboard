class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_login
    if !user_signed_in?
      if(params[:controller]!="home")
			   redirect_to "/", :flash => { :notice => "Please Login" }
      end
			return false
		elsif (current_user.name.nil? or current_user.name.empty? ) && ( params[:action]!="settings" && params[:controller]!="users")
			redirect_to user_profile_path ,:flash => {:notice => 'Update your Name'}
			return false
    end
    session[:channel] = "/public_board"
		true
  end

  def set_current_user_id
  	  User.current_id = current_user
  end

  def after_sign_in_path_for(resource)
    session[:channel] = "/public_board"
  	if (resource.name.nil? or resource.name.empty? )
    	user_profile_path
    else
			set_current_user_id
    	notices_url
    end
  end
  def publish(board_type)
     exec_js = "sync_notices();"
      PrivatePub.publish_to("/public_board",exec_js)
      #PrivatePub.publish_to("/user_#{current_user.name}",exec_js)
  end
  # publis to author
  def pubdlish(board_type)

    puts board_type + ' asdfdsfsdf sadfsd'
    if board_type == 'public'
      puts 'public '

      public_notices=Notice.public_notices

      notices = []

      public_notices.each do |notice|
                notices.push({:id =>  notice.id ,
                      :title => notice.title,
                      :user_color => notice.user_color,
                      :content => notice.content.html_safe,
                      :author => notice.user_name
                    })

      end
      puts 'before'
      # PrivatePub.publish_to(session[:channel],"load_notice(#{notices.to_json},'public')")

      exec_js = "
                $('#board_public ul').empty();
                var a =JSON.parse('#{notices.to_json}');
              $.each(a, function(index, element) {
                load_notice('#{current_user.name}',element,'public');
              });
            " 
     exec_js = "sync_notices();
            "


      PrivatePub.publish_to("/public_board",exec_js)

      puts 'published'

      true
    else

      puts 'Private '

      private_notices=current_user.noticeboard.notices.private_notices

      puts private_notices.inspect

      notices = []

      private_notices.each do |notice|
        notices.push({:id =>  notice.id ,
                      :title => notice.title,
                      :user_color => current_user.color,
                      :content => notice.content,
                      :author => notice.user_name
                    })

      end
      puts 'before'
      # PrivatePub.publish_to(session[:channel],"load_notice(#{notices.to_json},'public')")

      exec_js = "
                $('#board_private ul').empty();
                var a =JSON.parse('#{notices.to_json}');
                $.each(a, function(index, element) {
                  load_notice('#{current_user.name}',element,'private');
                });
              "
     exec_js = "sync_notices();
            "
              puts "/user_#{current_user.name}";
      PrivatePub.publish_to("/user_#{current_user.name}",exec_js)

      puts 'published'

      true

    end
  end

end

class ApplicationController < ActionController::Base
  protect_from_forgery
	def require_login
   if !user_signed_in?
			redirect_to "/", :flash => { :notice => "Please Login" }
			return false
		elsif (current_user.name.nil? or current_user.name.empty? ) and !(request[:controller] = 'Users'  and ( request[:action] == 'update'  or request[:action] ==  'profile' ) )
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
    	root_url
    end
  end

  # publis to author
  def self.publish(board_type,username)

    if board_type == 'public'
      puts 'public '

      public_notices=::Notice.public_notices.select("id,author,title,content,updated_at")

      notices = []

      public_notices.each do |notice|
                notices.push({:id =>  notice.id ,
                      :title => notice.title,
                      :user_color => User.find_by_name(notice.author).color,
                      :content => notice.content
                    })

      end
      puts 'before'
      # PrivatePub.publish_to(session[:channel],"load_notice(#{notices.to_json},'public')")

      exec_js = "
                $('#board_public ul').empty();
                var a =JSON.parse('#{notices.to_json}');
              $.each(a, function(index, element) {
                load_notice('#{username}',element,'public');
              });
            "


      PrivatePub.publish_to("/public_board",exec_js)

      puts 'published'

      true
    else

      user = User.find_by_name(username)

      puts 'Private '

      private_notices=user.noticeboard.notices.private_notices.select("id,author,title,content,updated_at")

      puts private_notices.inspect

      notices = []

      private_notices.each do |notice|
        notices.push({:id =>  notice.id ,
                      :title => notice.title,
                      :user_color => user.color,
                      :content => notice.content
                    })

      end
      puts 'before'
      # PrivatePub.publish_to(session[:channel],"load_notice(#{notices.to_json},'public')")

      exec_js = "
                $('#board_private ul').empty();
                var a =JSON.parse('#{notices.to_json}');
                $.each(a, function(index, element) {
                  load_notice('#{username}',element,'private');
                });
              "

              puts "/user_#{username}";
      PrivatePub.publish_to("/user_#{username}",exec_js)

      puts 'published'

      true

    end
  end

end

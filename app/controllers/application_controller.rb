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
		true
  end

  def set_current_user_id
  	  User.current_id = current_user
  end

  def after_sign_in_path_for(resource)
  	if (current_user.name.nil? or current_user.name.empty? )
    	user_profile_path
    else
			set_current_user_id
    	root_url
    end
  end
end

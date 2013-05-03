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


  def after_sign_in_path_for(resource)
    user_profile_path
  end

end

class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_login
   if !user_signed_in?
			redirect_to "/", :flash => { :notice => "Please Login" }
			return false
		end
		true
  end

end

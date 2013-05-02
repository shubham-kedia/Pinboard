class ApplicationController < ActionController::Base
  protect_from_forgery
  def require_login
   if !current_user
			redirect_to "/", :flash => { :notice => "Please Login" }
		end
  end
end

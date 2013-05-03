class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_login
  	puts 'in ' + user_signed_in?.to_s;
   if !user_signed_in?
			redirect_to "/", :flash => { :notice => "Please Login" }
			return false
		end
		true
  end

end

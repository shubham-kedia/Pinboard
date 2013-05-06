class HomeController < ApplicationController
	before_filter :require_login
  def index
  	@public_notices=Notice.public_notices
  end
	def validate
	  res=false
	  case params[:type]
	    when "email"
	      res="true" if(User.where(:email=>params[:user]["email"]).count==0)
	  end
	  if params[:reverse]
	    res=(res=="true") ? "false" : "true"
	  end
	  render :text=> res and return
	end
end

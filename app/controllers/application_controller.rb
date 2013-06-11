class ApplicationController < ActionController::Base
  protect_from_forgery
before_filter :set_locale
 
def set_locale
  session[:language] = params[:locale] if params[:locale]
  lang = session[:language] || params[:locale] || I18n.default_locale
  I18n.locale = lang
end
def default_url_options(options={})
  logger.debug "default_url_options is passed options: #{options.inspect}\n"
  { :locale => I18n.locale }
end
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
		true
  end

  def set_current_user_id
  	  User.current_id = current_user
  end

  def after_sign_in_path_for(resource)
   	if (resource.name.nil? or resource.name.empty? )
    	user_profile_path
    else
			set_current_user_id
    	notices_url
    end
  end
  def publish(board_type)
     exec_js = "sync_notices();"
      PrivatePub.publish_to(session[:channel],exec_js)
      #PrivatePub.publish_to("/user_#{current_user.name}",exec_js)
  end

  def current_team
    Team.find(session[:team_id])
  end


  def get_board(access_type)
    user=current_user
    if access_type == "private"
      board = user.noticeboard.nil? ? user.create_noticeboard(:name=>"board") : user.noticeboard
    else
      team = current_team
      board = team.noticeboard.nil? ? team.create_noticeboard(:name=>"board") : team.noticeboard
    end
    board
  end
  
end

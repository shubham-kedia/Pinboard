class Users::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    text= ""
    status = false
    team = Team.find_by_name(params[:user][:team])
    if team
      team_id = team.id
      status = false
      user = User.find_by_email(params[:user][:email])
      if user
        if user.valid_password?(params[:user][:password])
          if user.teams.map(&:id).include? team_id
            session[:team_id] = team_id
            status = true
            resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
            sign_in(resource_name, resource)
            redirect_to notices_path unless request.xhr?
          else
            text="Selected team is invalid"
            redirect_to root_url unless request.xhr?
    	     end
        else
          text="Invalid Password"
        end
      else
        text="Invalid username"
      end
    else
      text="Team does not exist"
    end
    render :text=>{"status"=>status,"text"=>text}.to_json()  if request.xhr?
  end
end
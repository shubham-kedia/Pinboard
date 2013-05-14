class Users::SessionsController < Devise::SessionsController
  def new
    super
  end
  def create
      team_id = Team.find(params[:user][:team_id]).id
      user = User.find_by_email(params[:user][:email])
      if team_id == user.team_id
        resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
     	  sign_in_and_redirect(resource_name, resource)
      else
        redirect_to root_url
		  end
     #respond_with resource, :location => redirect_location(resource_name, resource)
   end
end
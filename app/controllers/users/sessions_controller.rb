class Users::SessionsController < Devise::SessionsController
  def create
     resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
     team_id = Team.find(params[:user][:team_id])
     if team_id == resource.team_id
     	sign_in(resource_name, resource)
			else
			 redirect_to "/"
     end


     #respond_with resource, :location => redirect_location(resource_name, resource)
   end
end
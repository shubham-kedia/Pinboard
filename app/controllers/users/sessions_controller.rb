class SessionsController < Devise::SessionsController
  def create
     resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
     if Team.where("name=?",params[:team])
     else
     	Team.create(:name=>params[:team])
      end

     sign_in(resource_name, resource)
     respond_with resource, :location => redirect_location(resource_name, resource)
   end
end
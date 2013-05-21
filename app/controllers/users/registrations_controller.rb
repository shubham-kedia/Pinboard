class Users::RegistrationsController < Devise::RegistrationsController
def new

    super
  end

  def create
    team = Team.find_or_create_by_name(params[:user][:team])
    team.users.create(params[:user].except(:team))
    if request.xhr?
      render :json=> {:status=>true,:team=>Team.all.collect {|p| p.name },:team_name=>team.name,:team_id=>team.id}
    else
      redirect_to new_user_session_url
    end
    #sign_in_and_redirect user
  end

  # def update
  #   super
  # end

end
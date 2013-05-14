class Users::RegistrationsController < Devise::RegistrationsController
def new
    super
  end

  def create
    #user = User.create(params[:user])
    #id=Team.select(:id).where("name=?",params[:team_id])

    User.create(params[:user])
    redirect_to new_user_session_url
    #sign_in_and_redirect user
  end

  # def update
  #   super
  # end

end
class Users::RegistrationsController < Devise::RegistrationsController
def new
    super
  end

  def create
    user = User.create(params[:user])

    #user.create_detail(:name=>params[:user_name],:gender=>params[:user_gender])
    redirect_to new_user_session_url
    #sign_in_and_redirect user
  end

  # def update
  #   super
  # end

end
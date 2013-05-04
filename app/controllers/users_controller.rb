class UsersController < ApplicationController

	before_filter :require_login

  def profile
    @user = current_user
  end

  def update

  	user = current_user
		if !params[:user][:password].nil? and params[:user][:password].empty?
			params[:user].delete(:password)
			params[:user].delete(:password_confirmation)

			current_user.update_attributes(params[:user])
			sign_in(user,:bypass => true)

		else
			 if current_user.update_attributes(params[:user])
					sign_in(user,:bypass => true)
			 end
		end

  	redirect_to notices_path
  end

  def board_settings

  	@setting = current_user.setting

  	render :layout => false

  end
end

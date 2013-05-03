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
		end

		user.update_attributes(params[:user])


		puts user.errors.inspect

		puts user.valid?

		sign_in(user)

  	redirect_to notices_path
  end
end

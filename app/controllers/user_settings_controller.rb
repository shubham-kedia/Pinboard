class UserSettingsController < ApplicationController
  def index
  end

  def show
  end

  def edit
  end

  def destroy
  end

  def update
    if current_user.setting.update_attributes(params[:user_settings])
      render :js => "alert('Settings Updated'); $('#setting_modal').modal('hide');"
    else
      render :js => "alert('Updation Failed');"
    end
  end
end

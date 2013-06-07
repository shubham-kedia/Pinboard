class UsersController < ApplicationController

	before_filter :require_login

  def profile
    @user = current_user
  end

  def update
  	user = current_user
  		 		unless params[:team_ids].nil?
	 			to_be_deleted = user.teams.map(&:id)-params[:team_ids].map{|m| m.to_i}
		    to_be_added =params[:team_ids].map{|m| m.to_i} - user.teams.map(&:id)
		    puts to_be_added
		    puts to_be_deleted
	      to_be_added.each do |team_id|
	        user.teams << Team.find(team_id)
	      end
	      user.save
	      to_be_deleted.each do | team_id|
	      	user.teams.delete(Team.find(team_id))
	      end
	    end
	    unless params[:new_team].nil?
	      user.teams << Team.find_or_create_by_name(params[:new_team]) 
	      user.save
	    end
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

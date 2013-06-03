class Users::RegistrationsController < Devise::RegistrationsController
def new

    super
  end

  def create
    user =  User.create(params[:user])
    unless params[:team_ids].nil?
      params[:team_ids].each do |team_id|
        user.teams<< Team.find(team_id.to_i)
      end
      user.save
    end
    unless params[:new_team].nil?
      user.teams << Team.find_or_create_by_name(params[:new_team]) 
      user.save
    end
    if request.xhr?
      render :json=> {:status=>true,:team=>Team.all.collect {|p| {"id"=>p.id,"name"=>p.name} }}
    else
      redirect_to new_user_session_url
    end
    #sign_in_and_redirect user
  end

  # def update
  #   super
  # end

end
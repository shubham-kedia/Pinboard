class NoticesController < ApplicationController
	before_filter :require_login
  def index
  	@user=current_user
  	@color=@user.color
  	@private_notices=nil
    unless @user.noticeboard.nil?
   		@private_notices=@user.noticeboard.notices.private_notices
    end
  
  	@public_notices=Notice.public_notices
  end

  def new
   
  end

  def create
  	@user=current_user
  	if @user.noticeboard.nil?
  		@board=@user.create_noticeboard(:name=>"board")
    else
    	@board=@user.noticeboard
    end
    params[:notice]["author"] = @user.name
    puts params.inspect
    @notice=@board.notices.create(params[:notice])
    redirect_to :controller => 'notices' , :action=> :index
  end

  def delete
  end

  def update
  end
end

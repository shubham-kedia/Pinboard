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

  def destroy
    begin
    	notice = Notice.find(params[:id])
    	notice.destroy
      render :json => {:status => 1}
    rescue
      render :json => {:status => 0}
    end
    # redirect_to :controller => 'notices' , :action=> :index
  end

  def update
  	@notice.find(params[:id])
    @notice=@notice.update_attributes(:title=>params[:title],:content=>[:content])
  end
end

class NoticesController < ApplicationController
	before_filter :require_login
  def index
  	@user=current_user
  	@color=@user.color
  	@private_notices=nil
    unless @user.noticeboard.nil?
   		@private_notices=@user.noticeboard.notices.notice_with_settings(@user).private_notices
    end
  	@public_notices=Notice.notice_with_settings(@user).public_notices
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
    render :js => '$("#myModal_new").modal("hide");'
    #redirect_to :controller => 'notices' , :action=> :index
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
    @notice = Notice.find(params[:id])
    @notice=@notice.update_attributes(params[:notice])
    render :js => '$("#myModal_new").modal("hide");'
  end

  def make_private
    begin
      notice = Notice.find(params[:id])
      notice=notice.update_attributes(:access_type=>"private")
      render :json => {:status => 1}
    rescue
      render :json => {:status => 0}
    end
  end

  def make_public
    begin
      notice = Notice.find(params[:id])
      notice=notice.update_attributes(:access_type=>"public")
      render :json => {:status => 1}
    rescue
      render :json => {:status => 0}
    end
  end

def load_notices
    @user=current_user
    @color=@user.color
    @private_notices=nil
    unless @user.noticeboard.nil?
      @private_notices=@user.noticeboard.notices.notice_with_settings(@user).private_notices.select("id,author,title,content,updated_at")
    end

    @public_notices=Notice.notice_with_settings(@user).public_notices.select("id,author,title,content,updated_at")

    render :json => { :status => 1,
                      :user_name => @user.name,
                      :user_id => @user.id,
                      :user_color => @user.color,
                      :public_notice => @public_notices,
                      :private_notice => @private_notices
                     }
  end

  def search_by_keyword
    @user=current_user
    @color=@user.color
    if params[:type] == 'public'
      notices = Notice.notice_with_settings(@user).public_notices
    else
      notices = Notice.notice_with_settings(@user).private_notices
    end
    if notices
      notices = notices.where('content like ? or title like ?' , "%#{params[:keyword]}%","%#{params[:keyword]}%").select("id,author,title,content,updated_at")
    end
    render :json => { :status => 1,
                      :user_name => @user.name,
                      :user_id => @user.id,
                      :user_color => @user.color,
                      :notices => notices
                     }
  end


  def sendemail
    begin
      notice = Notice.find(params[:id])
      NoticeMailer.send_notice_email(current_user.name , params[:email],notice.title,notice.created_at.strftime("%d-%m-%Y"),notice.content).deliver
      render :json => {:status => 1}
    rescue
      render :json => {:status => 0}
    end
  end

end

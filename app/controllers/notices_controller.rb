class NoticesController < ApplicationController
	before_filter :require_login
  def index
  	@user=current_user
  	@color=@user.color
  	@private_notices=nil
    unless @user.noticeboard.nil?
   		@private_notices=@user.noticeboard.notices.notice_with_settings(@user).private_notices
    end
  	@public_notices=Notice.notice_with_settings(@user).public_notices.order(:user_id)
  end

  def new

  end

  def create
  	user=current_user
  	if user.noticeboard.nil?
  		board=user.create_noticeboard(:name=>"board")
    else
    	board = user.noticeboard
    end
    params[:notice][:user_id] = current_user.id
    notice = board.notices.create(params[:notice].except(:img))
    if params[:notice][:img]
      notice_image = params[:notice][:img]
      notice_image.each do |img|
        notice.images.create(:img=>img)
      end
    end
    begin
      publish(notice.access_type)
    rescue
    end
    render :js => '$("#myModal_new").modal("hide"); sync_notices();'
    #redirect_to :controller => 'notices' , :action=> :index
  end

  def destroy
    type = ""
    begin
    	notice = Notice.find(params[:id])
      type = notice.access_type
    	notice.destroy

    begin
      publish(type)
    rescue
    end

      render :json => {:status => 1}
    rescue
      render :json => {:status => 0}
    end

    # redirect_to :controller => 'notices' , :action=> :index
  end

  def update
    notice = Notice.find(params[:id])
    notice.update_attributes(params[:notice].except(:img))
    if params[:notice][:img]
      notice_image = params[:notice][:img]
      notice_image.each do |img|
        notice.images.create(:img=>img)
      end
    end
    # params[:notice][:user_id] = current_user.id
    # if 
    begin
      publish(notice.access_type)
    rescue
    end

    render :js => '$("#myModal_new").modal("hide");sync_notices();'
  end

  def deleteImage
    begin
      image = Image.find(params[:id])
      image.destroy
      begin
        publish("")
      rescue
      end

      render :json => {:status => 1}
    rescue
      render :json => {:status => 0}
    end
  end

  def make_private
    begin
      notice = Notice.find(params[:id])
      notice.update_attributes(:access_type=>"private")

      begin
        publish("private")
      rescue
      end

      render :json => {:status => 1}
    rescue
      render :json => {:status => 0}
    end
  end

  def make_public
    begin
      notice = Notice.find(params[:id])
      notice.update_attributes(:access_type=>"public")

      begin
        publish("public")
      rescue
      end

      render :json => {:status => 1}
    rescue
      render :json => {:status => 0}
    end
  end

def load_notices
    user=current_user
    color=user.color
    private_notices = nil
    unless user.noticeboard.nil?
      private_notices = user.noticeboard.notices.notice_with_settings(user).private_notices
    end

    # public_notices=Notice.notice_with_settings(user).public_notices.select("id,author,title,content,updated_at")
    public_notices=Notice.notice_with_settings(user).public_notices.order(:user_id)

    render :json => { :status => 1,
                      :user_name => user.name,
                      :user_id => user.id,
                      :user_color => user.color,
                      :public_notice => public_notices.as_json,
                      :private_notice => private_notices.as_json
                     }
  end

  def search_by_keyword
    @user=current_user
    @color=@user.color
    if params[:type] == 'public'
      notices = Notice.notice_with_settings(@user).public_notices
    else
      # notices = Notice.notice_with_settings(@user).private_notices
      notices = @user.noticeboard.notices.notice_with_settings(@user).private_notices
    end
    if notices
      notices = notices.where('content like ? or title like ?' , "%#{params[:keyword]}%","%#{params[:keyword]}%")
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

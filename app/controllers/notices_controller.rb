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

    public_notices_array = Array.new

      @public_notices.each do |notice|
        public_notices_array.push notice
      end

    private_notices_array = Array.new

      unless @private_notices.nil?
        @private_notices.each do |notice|
          private_notices_array.push notice
        end
      end

    render :json => { :status => 1,
                      :user_name => @user.name,
                      :user_id => @user.id,
                      :user_color => @user.color,
                      :public_notice => public_notices_array,
                      :private_notice => private_notices_array
                     }
  end

  def search_by_keyword
    if params[:type] == 'public'
      notice = Notice.public_notices
    else
      notice = Notice.notice_with_settings(@user).private_notices
    end
      notice = notice.where('content like ? or title like ?' , "%#{params[:keyword]}%","%#{params[:keyword]}%").select("id,author,title,content,updated_at")

      render :json => {:status => 1}

      # notice.each do |note|
      #     private_notices_array.push note
      # end


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

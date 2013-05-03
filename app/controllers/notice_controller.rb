class NoticeController < ApplicationController

  before_filter :require_login

  def index
  	@user=current_user
  	@private_notices=@user.noticeboard.notices.private_notices
  	@public_notices=@user.noticeboard.notices.public_notices
  end

  def create
  end

  def delete
  end

  def update
  end
end

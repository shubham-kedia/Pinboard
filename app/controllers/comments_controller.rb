class CommentsController < ApplicationController
	
	def index
	end

	def new
	end

	def create
		user=current_user
		
		Comment.create(params[:comment])

		begin
		  publish("")
		rescue
		end
		render :js => '$("#myModal_comment").modal("hide"); sync_notices();'
		#redirect_to :controller => 'notices' , :action=> :index
	end

end

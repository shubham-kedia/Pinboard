class HomeController < ApplicationController
  def index
  	@public_notices=Notice.public_notices
  end
end

class WelcomeController < ApplicationController
  
  def index
    redirect_to (page_path("Home"))
  end
end

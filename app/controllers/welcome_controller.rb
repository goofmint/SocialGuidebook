class WelcomeController < ApplicationController
  
  def index
    redirect_to (page_path(Page::HomeTitle))
  end
end

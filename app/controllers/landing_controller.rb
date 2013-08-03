class LandingController < ApplicationController
  def index
    if @user
      redirect_to :dashboard
    else
      # in case we ever want a different landing vs. login page
      redirect_to :login
    end
  end
end

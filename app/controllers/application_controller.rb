class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :identify_user
  before_filter :enforce_login

  def identify_user
    @user = session[:user_id] && User.find(session[:user_id])
  end

  def enforce_login
    if !@user
      redirect_to :login
    end
  end
end

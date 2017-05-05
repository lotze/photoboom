class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :identify_user
  before_action :enforce_login

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def identify_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def enforce_login
    if !@current_user
      redirect_to :login
    end
  end

  def require_admin
    if !@current_user.admin
      flash[:error] = "Requires admin! Logging you out. Please log in as admin."
      redirect_to :logout
    end
  end
end

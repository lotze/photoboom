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
    current_user
  end

  def enforce_login
    if !current_user
      session[:redirect_to] = request.original_url unless request.original_url.include?('signout') || request.original_url.include?('logout')
      redirect_to :login
    end
  end

  def require_admin
    if !current_user.admin
      flash[:error] = "Requires admin! Logging you out. Please log in as admin."
      redirect_to :logout
    end
  end

  def set_game
    if @registration
      @game = @registration.game
    elsif @photo
      @game = @photo.game
    elsif @mission
      @game = @mission.game
    elsif @team
      @game = @team.game
    elsif params[:game_id]
      @game = Game.find(params[:game_id])
    elsif params['mission'] && params['mission']['game_id']
      @game = Game.find(params['mission']['game_id'])
    end
  end

  def require_game_admin
    unless @game.is_admin?(current_user)
      flash[:error] = "Only the game organizer can do that."
      return redirect_to root_path
    end
  end
end

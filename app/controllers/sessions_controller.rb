class SessionsController < ApplicationController
  skip_before_action :enforce_login, :only => [:new, :create, :destroy, :failure]
  protect_from_forgery :except => :create

  def new
    # Display buttons and form for logging in
  end

  def create
    auth_hash = request.env['omniauth.auth']

    if current_user
      # Means our user is signed in. Add the authorization to the user
      current_user.add_provider(auth_hash)
    else
      # Log them in or sign them up
      auth = Authorization.find_or_create(auth_hash)

      # Create the session
      session[:user_id] = auth.user.id
    end

    flash.delete(:error) if flash[:error] == 'You need to sign in before accessing this page!'
    redirect_destination = session.delete(:redirect_to)
    redirect_to redirect_destination || root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to :login
  end

  def failure
    redirect_to root_url, alert: "Authentication failed, please try again."
  end
end

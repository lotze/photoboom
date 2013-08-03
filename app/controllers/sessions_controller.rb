class SessionsController < ApplicationController
  skip_before_filter :enforce_login, :only => [:new, :create, :destroy, :failure]

  def new
    # Display buttons and form for logging in
  end

  def create
    auth_hash = request.env['omniauth.auth']

    if @user
      # Means our user is signed in. Add the authorization to the user
      @user.add_provider(auth_hash)
    else
      # Log them in or sign them up
      auth = Authorization.find_or_create(auth_hash)

      # Create the session
      session[:user_id] = auth.user.id
    end

    redirect_to :dashboard
  end

  def destroy
    session[:user_id] = nil
    redirect_to :login
  end

  def failure
  end
end

class RegistrationsController < ApplicationController
  before_action :set_registration, only: [:show, :edit, :update, :destroy]
  before_action :set_game
  before_action :require_game_admin, except: [:new, :create]

  # GET /registrations
  # GET /registrations.json
  def index
    @registrations = @game.registrations
  end

  # GET /registrations/1
  # GET /registrations/1.json
  def show
  end

  # GET /registrations/new
  def new
    if @game.over?
      flash[:notice] = "That game is over."
      return redirect_to games_path
    end
    
    @registration = Registration.new
    @registration.game = @game
    @event_name = "the photo scavenger hunt \"#{@game.name}\""
    @grantee = @game.organizer.name == 'Thomas Lotze' ? "#{@game.organizer.name} and #{ENV['HOSTNAME']}" : "Thomas Lotze, #{@game.organizer.name}, and #{ENV['HOSTNAME']}"
  end

  # GET /registrations/1/edit
  def edit
  end

  # POST /registrations
  # POST /registrations.json
  def create
    if @game.over? && !@game.is_admin?(current_user)
      flash[:notice] = "That game is over."
      return redirect_to games_path
    end

    sanctified_params = registration_params
    sanctified_params = sanctified_params.merge(user_id: current_user.id)
    @registration = Registration.new(sanctified_params)

    respond_to do |format|
      if @registration.save
        format.html do 
          redirect_destination = session.delete(:redirect_to)
          redirect_to (redirect_destination || root_path), notice: "Successfully registered."
        end
        format.json { render action: 'show', status: :created, location: @registration }
      else
        format.html { render action: 'new' }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /registrations/1
  # PATCH/PUT /registrations/1.json
  def update
    respond_to do |format|
      if @registration.update(registration_params)
        format.html { redirect_to @registration, notice: 'Registration was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registrations/1
  # DELETE /registrations/1.json
  def destroy
    @registration.destroy
    respond_to do |format|
      format.html { redirect_to registrations_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration
      @registration = Registration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def registration_params
      params.require(:registration).permit(:game_id, :user_id, :team_id, :agree_waiver, :agree_photo, :legal_name)
    end
end

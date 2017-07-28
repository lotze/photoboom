class RegistrationsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]
  before_action :set_game

  # GET /memberships
  # GET /memberships.json
  def index
    @registrations = @game.registrations
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @registration = Registration.new
    @registration.game = @game
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    sanctified_params = membership_params
    unless current_user.admin || @game.is_admin?(current_user)
      sanctified_params = sanctified_params.merge(user_id: current_user.id)
    end
    @registration = Registration.new(sanctified_params)

    respond_to do |format|
      if @registration.save
        format.html { redirect_to @registration, notice: 'Registration was successfully created.' }
        format.json { render action: 'show', status: :created, location: @registration }
      else
        format.html { render action: 'new' }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @registration.update(membership_params)
        format.html { redirect_to @registration, notice: 'Registration was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @registration.destroy
    respond_to do |format|
      format.html { redirect_to registrations_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @registration = Registration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:registration).permit(:game_id, :user_id, :team_id)
    end
end

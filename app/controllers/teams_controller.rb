class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy, :add_member, :remove_member, :rename]
  before_action :set_game
  before_action :require_admin, except: [:rename]
  before_action :require_game_admin, only: [:force_add]

  def missing
    photo_missing_user_ids = Photo.where(game_id: @game.id, team_id: nil).distinct.pluck(:user_id)
    @missing_users = photo_missing_user_ids.map{|user_id| User.find_by(id: user_id)}
  end

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # POST /teams/1/rename
  def rename
    if params['team_name']
      @team.name = params['team_name']
      if !@team.save
        flash[:error] = @team.errors.full_messages
      end
    end
    redirect_to manage_team_path
  end

  def force_add
    @team = Team.find(params[:team_id])
    begin
      @user = User.find(params['user_id'])
      @user.set_team(@team)
    rescue => e
      if e.to_s =~ /must first register/
        Registration.create!(
          user_id: @user.id,
          team_id: @team.id,
          game_id: @game.id,
          agree_waiver: true, agree_photo: true, legal_name: 'Admin-approved Team Addition'
        )
      else
        raise e
      end
    end
    redirect_to action: :show, id: @team.id
  end

  # POST /teams/1/add_member
  def add_member
    @user = User.find(params['user_id'])
    @user.set_team(@team)
    redirect_to action: :show, id: @team.id
  end

  # POST /teams/1/remove_member
  def remove_member
    @user = User.find(params['user_id'])
    @team.users.delete(@user)
    redirect_to action: :show, id: @team.id
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name, :game_id)
    end
end

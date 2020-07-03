class MissionsController < ApplicationController
  before_action :set_mission, only: [:show, :edit, :update, :destroy]
  before_action :set_game
  before_action :require_game_admin

  def order
    @missions = @game.missions
  end

  def change_order
    # get missions and new codenums
    params["mission_ids"].each_with_index do |mission_id, new_codenum|
      mission = Mission.find(mission_id)
      if mission.codenum != new_codenum + 1
        mission.update_attributes!(codenum: new_codenum + 1)
      end
    end
    flash[:notice] = "Successfully reordered!"
    redirect_to missions_path(game_id: @game.id)
  end

  def export
    mission_list = @game.missions.map do |mission|
      "#{mission.points} #{mission.name}: #{mission.description}"
    end
    render plain: mission_list.join("\n")
  end

  def import
    codenum = (@game.missions.empty? ? 0 : @game.missions.map(:codenum).max) + 1
    if params["mission_list_text"]
      error_lines = []
      # parse and create new missions
      params["mission_list_text"].split("\n").each do |line|
        # TODO: would be better to not hardcode the default points here, since it's defined elsewhere
        points = 10
        if line =~ /^(\d+)/
          points = $1
          line = line.sub(/^\d+\s*/, '')
        end
        if line =~ /^([^:]+):\s*(.*)$/
          name = $1
          description = $2
          begin
            Mission.create!(game: @game, name: name, description: description, points: points, codenum: codenum)
            codenum = codenum + 1
          rescue => e
            error_lines << line + " (#{e})"
          end
        else
          unless line =~ /^\s*$/
            error_lines << line
          end
        end
      end
      unless error_lines.empty?
        flash[:error] = "Errors processing the following lines: " + error_lines.join("----")
      end
      redirect_to missions_path(game_id: @game.id)
    end
    # otherwise, display form
  end

  # GET /missions
  # GET /missions.json
  def index
    @missions = @game.missions
  end

  # GET /missions/1
  # GET /missions/1.json
  def show
  end

  # GET /missions/new
  def new
    @mission = Mission.new(game: @game, points: 10)
  end

  # GET /missions/1/edit
  def edit
  end

  # POST /missions
  # POST /missions.json
  def create
    @mission = Mission.new(mission_params)

    respond_to do |format|
      if @mission.save
        format.html { redirect_to missions_order_path(game_id: @game.id), notice: 'Mission was successfully created.' }
        format.json { render :show, status: :created, location: @mission }
      else
        format.html { render :new }
        format.json { render json: @mission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /missions/1
  # PATCH/PUT /missions/1.json
  def update
    respond_to do |format|
      if @mission.update(mission_params)
        format.html { redirect_to missions_path(game_id: @game.id), notice: 'Mission was successfully updated.' }
        format.json { render :show, status: :ok, location: @mission }
      else
        format.html { render :edit }
        format.json { render json: @mission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /missions/1
  # DELETE /missions/1.json
  def destroy
    @mission.destroy
    respond_to do |format|
      format.html { redirect_to missions_path(game_id: @game.id), notice: 'Mission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mission
      @mission = Mission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mission_params
      params.require(:mission).permit(:name, :description, :game_id, :points, :codenum)
    end
end

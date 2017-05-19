class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy, :recent_photos, :check_email, :mission_sheet, :mission_page]
  before_action :require_admin

  def recent_photos
    @photos = @game.photos.order(created_at: :desc).includes(:team).includes(:mission).limit(params['n'] || 20)
    render 'photos/index'
  end

  def check_email
    @time_checked = Time.now
    email_updater = EmailUpdater.new
    @photos = email_updater.update
  end

  # TODO: convert to pdf and link to pdf
  # TODO: fix svg text display (probably assume single-line, use ruby to split descriptions)
  def mission_page
    page = (params['page'] || '1').to_i
    num_per_page = 14
    title_num = 2
    if page == 1
      template_basename = 'title_mission_template.svg'
      mission_codenums =(1..(num_per_page - title_num)).to_a
    else
      template_basename = 'mission_template.svg'
      start_num = (num_per_page - title_num) + (page - 2) * num_per_page + 1
      end_num = start_num + num_per_page - 1
      mission_codenums =(start_num..end_num).to_a
    end
    # open template; make substitutions; render as svg
    template_file = Rails.root.join('data', template_basename)
    # error if no template exists
    unless File.exists?(template_file)
      flash[:error] = "No sheet template."
      return redirect_to root_path
    end
    sheet_template = IO.read(template_file)
    sheet_template.sub!('game.name', @game.name)
    sheet_template.sub!('game.date', @game.starts_at.strftime('%Y-%m-%d'))

    missions = @game.missions.where(codenum: mission_codenums)
    missions.each do |mission|
      sheet_template.sub!('mission.codenum', mission.codenum.to_s)
      sheet_template.sub!('mission.name', mission.name)
      sheet_template.sub!('mission.points', mission.points.to_s)
      sheet_template.sub!('mission.description', mission.description)
    end
    # replace any extra mission text fields
    sheet_template.gsub!('mission.codenum: mission.name', '')
    sheet_template.gsub!('Points: mission.points', '')
    sheet_template.gsub!('mission.points points', '')
    sheet_template.gsub!('mission.description', '')
    render inline: sheet_template, mime_type: Mime::Type.lookup("image/svg+xml")
  end

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @team = current_user.team(@game)
    if @team
      redirect_to team_path(@team)
    end
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    gp = game_params
    gp['starts_at'] = Time.parse(gp['starts_at'])
    gp['organizer_id'] = current_user.id
    @game = Game.new(gp)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render action: 'show', status: :created, location: @game }
      else
        format.html { render action: 'new' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id] || Game.default_game_id)
    end

    def parse_datetime(datetime, tz='US/Pacific')
      # hack for dealing with slashes :s
      datetime = "#{$3}-#{$1}-#{$2}#{$4}" if /^(\d{2})\/(\d{2})\/(\d{4})(.*)/ =~ datetime
      ActiveSupport::TimeZone.new(tz).parse(datetime)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      p = params.require(:game).permit(:name, :starts_at, :ends_at, :min_team_size, :max_team_size)
      p['starts_at'] = parse_datetime(p['starts_at'])
      p['ends_at'] = parse_datetime(p['ends_at'])
      return p
    end
end

class GamesController < ApplicationController
  before_action :set_game, except: [:index, :new, :create, :hrsfans]
  before_action :require_game_admin, except: [:index, :new, :create, :signup, :hrsfans]
  layout 'print', only: [:rules]

  def hrsfans
    @game = Game.find_by(name: 'HRSFA/NS Scavenger Hunt 2017')
    redirect_to dashboard_path(game_id: @game.id)
  end

  def rules
    # TODO: force unique mission numbers before displaying for printing
  end

  def rules_pdf
    filename = "./tmp/game_#{@game.id}.pdf"
    namespace = OpenStruct.new(
      :game => @game,
      :hostname => request.base_url,
      :photo_email => ENV['PHOTO_SUBMIT_EMAIL']
    )
    layout = ERB.new(File.open(Rails.root.join('app','views','layouts','print.html.erb')).read.gsub!('<%= content_for?(:content) ? yield(:content) : yield %>', '<%= content %>'))
    template = layout.result(OpenStruct.new(
      :content => File.open(Rails.root.join('app','views','games','rules.html.erb')).read
    ).instance_eval { binding })

    template = ERB.new(File.open(Rails.root.join('app','views','games','_rules.html.erb')).read)
    filled_rules = template.result(namespace.instance_eval { binding })
    pdf = WickedPdf.new.pdf_from_string(filled_rules, :margin => {:top                => 0.5,
                         :bottom             => 0,
                         :left               => 0.5,
                         :right              => 0.5})
    File.open(filename, 'wb') do |file|
      file << pdf
    end
    send_file(filename, filename: 'rules.pdf', type: 'application/pdf', disposition: :inline)
  end

  def recent_photos
    @photos = @game.photos.order(created_at: :desc).includes(:team).includes(:mission).limit(params['n'] || 20)
    render 'photos/index'
  end

  def admin_review
    @photos = @game.photos.where(reviewed: false).order(created_at: :desc).includes(:team).includes(:mission).limit(params['n'] || 40)
    render 'photos/index'
  end

  def rejected
    @photos = @game.photos.where(rejected: true).order(:team_id, :mission_id).includes(:team).includes(:mission).limit(params['n'] || 40)
    render 'photos/index'
  end

  def check_email
    @time_checked = Time.now
    email_updater = EmailUpdater.new
    @photos = email_updater.update
  end

  # GET /games
  # GET /games.json
  def index
    if current_user.admin?
      @games = Game.all
    else
      @games = Game.upcoming.publicly_available
    end
  end

  def signup
  end

  # GET /games/1
  # GET /games/1.json
  def show
    redirect_to dashboard_path(game_id: @game.id)
  end

  # GET /games/new
  def new
    @game = Game.new
    if params[:latitude]
      timezone = Timezone.lookup(params[:latitude], params[:longitude])
      @game.timezone = ActiveSupport::TimeZone::MAPPING.key(timezone.name) || timezone.name
    end
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    gp = game_params
    gp['organizer_id'] = current_user.id
    @game = Game.new(gp)

    respond_to do |format|
      if @game.save
        format.html { redirect_to edit_game_path(@game), notice: 'Game was successfully created.' }
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
    def set_game
      @game = Game.find(params[:id])
    end

    def parse_datetime(datetime, timezone)
      # hack for dealing with slashes :s
      datetime = "#{$3}-#{$1}-#{$2}#{$4}" if /^(\d{2})\/(\d{2})\/(\d{4})(.*)/ =~ datetime
      ActiveSupport::TimeZone.new(timezone).parse(datetime)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      p = params.require(:game).permit(:name, :starts_at, :ends_at, :min_team_size, :max_team_size, :timezone, :start_location, :contact, :end_location)
      p['starts_at'] = parse_datetime(p['starts_at'], p['timezone'])
      p['ends_at'] = parse_datetime(p['ends_at'], p['timezone'])
      return p
    end
end

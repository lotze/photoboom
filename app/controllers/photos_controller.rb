class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy, :reject, :accept]
  before_action :set_game
  before_action :require_game_admin, except: [:create]

  # GET /photos
  # GET /photos.json
  def index
    @photos = @game.photos.includes(:mission).includes(:user)
    if params['order'] == 'random'
      @photos = @photos.shuffle
    elsif params['order'] == 'time'
      @photos = @photos.sort_by{|p| [p.submitted_at, p.team_id]}
    elsif params['order'] == 'team'
      @photos = @photos.sort_by{|p| [p.team.name, p.mission.codenum]}
    else
      # default is by mission, then team, then submission time
      @photos = @photos.sort_by{|p| [p.mission.codenum, p.team.name, p.submitted_at]}
    end
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos
  # POST /photos.json
  def create
    p = photo_params
    game = Game.find(p['game_id'])

    job_params = {
      user_id: current_user.id,
      team_id: current_user.team(game).try(:id),
      game_id: p[:game_id],
      mission_id: p[:mission_id],
      submitted_at: Time.now.to_s,
      tmp_file: File.absolute_path(p[:photo].tempfile.path),
      original_filename: p[:photo].original_filename,
      content_type: p[:photo].content_type
    }
    PhotoProcessor.perform_later job_params

    respond_to do |format|
      format.html { redirect_to play_path(game_id: game.id), notice: 'Thanks! Your photo is being processed.' }
      format.json { render :show, status: :processing }
    end
  end

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url, notice: 'Photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def reject
    @photo.reject!(params['notes'])
    redirect_to admin_review_path(id: @game.id)
  end

  def accept
    @photo.accept!(params['notes'])
    redirect_to admin_review_path(id: @game.id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:game_id, :mission_id, :user_id, :photo, :notes)
    end
end

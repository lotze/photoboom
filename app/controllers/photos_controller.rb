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
      @photos = @photos.sort_by{|p| [p.submitted_at, p.team_id || 0]}
    elsif params['order'] == 'team'
      @photos = @photos.sort_by{|p| [p.team_id || 0, p.mission.codenum]}
    else
      # default is by mission, then team, then submission time
      @photos = @photos.sort_by{|p| [p.mission.codenum, p.team_id || 0, p.submitted_at]}
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
    @game = Game.find(p['game_id'])
    @photo = Photo.new(p.merge(user: current_user, team: current_user.team(@game), submitted_at: Time.now, game: @game))

    respond_to do |format|
      if @photo.save
        if !Rails.env.development? && @photo.submitted_at > @photo.game.ends_at + 2.minutes # 2 minute grace period
          @photo.reject!('The game has ended!')
          format.html { redirect_to play_path(game_id: @photo.game_id), error: 'Error uploading photo! The game has already ended!' }
          format.json { render json: @photo.errors.merge(error: :game_over), status: :unprocessable_entity }
        else
          format.html { redirect_to play_path(game_id: @photo.game_id), notice: 'Your photo was successfully uploaded.' }
          format.json { render :show, status: :created, location: @photo }
        end
      else
        format.html { redirect_to play_path(game_id: @photo.game_id), error: 'Error uploading photo!' }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
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

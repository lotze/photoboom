class DashboardController < ApplicationController
  before_action :set_team, only: [:join_team]
  before_action :get_game
  # TODO: hack right now for HRSFANS photos
  # before_action :require_registration, except: [:register]
  before_action :require_registration, except: [:register, :slideshow]

  # get next game this player is signed up for, or redirect to list of games
  def get_game
    if params['game_id']
      @game = Game.find_by(id: params['game_id'])
    elsif current_user.next_game
      @game ||= current_user.next_game
    end
    if !@game
      redirect_to games_path
    end
  end

  # TODO: rename this 'direct_game' or something
  def next_game
    @team = current_user.team(@game)

    unless @team
      if @game.is_admin?(current_user) || !@game.over?
        return redirect_to show_teams_path(game_id: @game.id)
      else
        flash[:notice] = "Registration for that game is over."
        return redirect_to games_path
      end
    end

    if @game.upcoming?
      redirect_to manage_team_path(game_id: @game.id)
    elsif @game.long_over?
      redirect_to leaderboard_path(game_id: @game.id)
    elsif @game.over?
      redirect_to review_path(game_id: @game.id)
    else
      redirect_to play_path(game_id: @game.id)
    end
  end

  ##################################################################
  # pre-game: show and create/join a team
  ##################################################################

  def show_teams
    @teams = @game.teams
    @no_team_users = @game.without_team.map(&:user)
  end

  def set_team
    if params['team_id']
      @team = Team.find(params['team_id'])
    end
  end

  def join_team
    if @game.over?
      flash[:notice] = "That game is over."
      return redirect_to games_path
    end

    if !@team && params['team_name']
      team_name = params['team_name']
      normalized_team_name = Team.normalize_name(team_name)
      @team = Team.find_by(game: @game, normalized_name: normalized_team_name)
      unless @team
        @team = Team.create(game: @game, name: team_name)
      end
    end
    if @team
      begin
        current_user.set_team(@team)
        redirect_to next_game_path
      rescue => e
        flash[:error] = "Error; you must first register for the game."
        redirect_to show_teams_path(game_id: @game.id)
      end
    else
      flash[:error] = "Error; no such team."
      redirect_to show_teams_path(game_id: @game.id)
    end
  end

  ##################################################################
  # pre-game: manage team
  ##################################################################

  def manage_team
    @team = @current_user.team(@game)
  end

  def leave_team
    @team = @current_user.team(@game)
    membership = @current_user.registrations.find_by(game_id: @game.id)
    if membership.team == @team
      membership.update_attributes!(team_id: nil)
    end
    redirect_to next_game_path
  end

  ##################################################################
  # during-game: show missions and enable upload
  ##################################################################

  def review
    @team = @current_user.team(@game)
    @team_photos = Photo.where(game: @game, team: @team, rejected: false).includes(:mission)
    @missions = @team_photos.map {|p| p.mission}.uniq.sort_by(&:codenum)
  end

  def play
    if !@game.in_progress? && !current_user.admin
      flash[:error] = "Game is not in progress!"
      return redirect_to next_game_path
    end

    @team = @current_user.team(@game)
    # toggling between 'all' and 'only uncompleted'
    @filter_status = params['filter_status']
    team_photos = Photo.where(game: @game, team: @team, rejected: false)
    @photos_by_mission = {}
    if @filter_status == 'all'
      @photos_by_mission = team_photos.group_by(&:mission_id)
      @missions = @game.missions
    else
      completed_mission_ids = team_photos.map {|p| p.mission_id}.uniq
      @missions = @game.missions.find_all {|m| !completed_mission_ids.include?(m.id)}
    end
  end

  ##################################################################
  # post-game: show leaderboard and slideshow
  ##################################################################

  def leaderboard
    if @game.ends_at > Time.now && !@game.is_admin?(current_user)
      flash[:error] = "Game has not yet ended!"
      return redirect_to next_game_path
    end

    @photos = Photo.where(game: @game, rejected: false).includes(:team).includes(:mission)
    @missions_by_team = Hash[@photos.group_by{|p| p.team}.map {|team, photos| [team, photos.group_by(&:mission).map{|m, ph| m}.uniq]}]
    @total_by_team = Hash[@missions_by_team.map {|t, m| [t, m.map(&:points).sum]}]
  end

  def slideshow
    if @game.ends_at > Time.now && !@game.is_admin?(current_user)
      flash[:error] = "Game has not yet ended!"
      return redirect_to next_game_path
    end

    @max_width = params[:max_width].present? ? params[:max_width].to_i : 640
    @max_height = params[:max_height].present? ? params[:max_height].to_i : 480

    @photos = Photo.where(game: @game, rejected: false).includes(:team).includes(:mission)
    if params['order'] == 'random'
      @photos = @photos.shuffle
    elsif params['order'] == 'time'
      @photos = @photos.sort_by{|p| [p.submitted_at, p.team_id]}
    elsif params['order'] == 'team'
      @photos = @photos.sort_by{|p| [p.team.try(:name) || '', p.mission.codenum]}
    else
      # default is by mission, then team, then submission time
      @photos = @photos.sort_by{|p| [p.mission.codenum, p.team.try(:name) || '', p.submitted_at]}
    end
  end

end

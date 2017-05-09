class DashboardController < ApplicationController
  before_action :get_game
  # TODO: get next game this player is signed up for, or redirect to list of games
  def get_game
    @game = Game.find(params['game_id'] || Game.default_game_id)
  end

  def index
  end

  def next_game
    @team = @current_user.team(@game)

    unless @team
      return redirect_to show_teams_path(game_id: @game.id)
    end

    if @game.in_progress?
      redirect_to play_path(game_id: @game.id)
    elsif @game.over?
      redirect_to leaderboard_path(game_id: @game.id)
    elsif @game.upcoming?
      redirect_to manage_team_path(game_id: @game.id)
    end
  end

  ##################################################################
  # pre-game: show and create/join a team
  ##################################################################

  def show_teams
    @teams = @game.teams
  end

  def join_team
    if params['team_id']
      team = Team.find(params['team_id'])
    else
      team_name = params['team_name']
      normalized_team_name = Team.normalize_name(params['team_name'])
      team = Team.find_by(game: @game, normalized_name: normalized_team_name)
      unless team
        team = Team.create(game: @game, name: team_name)
      end
    end
    if team
      current_user.set_team(team)
      redirect_to next_game_path
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
    membership = @current_user.membership
    if membership.team == @team
      membership.destroy
    end
    redirect_to next_game_path
  end

  ##################################################################
  # during-game: show missions and enable upload
  ##################################################################

  def play
    if @game.starts_at > Time.now && !current_user.admin
      flash[:error] = "Game has not yet started!"
      return redirect_to next_game_path
    end

    @team = @current_user.team(@game)
    # toggling between 'all' and 'only uncompleted'
    @filter_status = params['filter_status']
    if @filter_status == 'all'
      @missions = @game.missions
    else
      @team_photos = Photo.where(game: @game, user: @team.users, rejected: false)
      completed_mission_ids = @team_photos.map {|p| p.mission_id}.uniq
      @missions = @game.missions.find_all {|m| !completed_mission_ids.include?(m.id)}
    end
  end

  ##################################################################
  # post-game: show leaderboard and slideshow
  ##################################################################

  def leaderboard
    if @game.ends_at > Time.now && !current_user.admin
      flash[:error] = "Game has not yet ended!"
      return redirect_to next_game_path
    end

    @photos = Photo.where(game: @game, rejected: false).includes(:team).includes(:mission)
    @missions_by_team = Hash[@photos.group_by{|p| p.team}.map {|team, photos| [team, photos.group_by(&:mission).map{|m, ph| m}.uniq]}]
    @total_by_team = Hash[@missions_by_team.map {|t, m| [t, m.map(&:points).sum]}]
  end

  def slideshow
    if @game.ends_at > Time.now && !current_user.admin
      flash[:error] = "Game has not yet ended!"
      return redirect_to next_game_path
    end

    @photos = Photo.where(game: @game, rejected: false).includes(:team).includes(:mission)
  end
end

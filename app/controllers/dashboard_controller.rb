class DashboardController < ApplicationController
  def index

  end

  def next_game
    # TODO: get next game this player is signed up for, or redirect to list of games
    @game = Game.default_game
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
    @game = Game.find(params['game_id'])
    @teams = @game.teams
  end

  def join_team
    game = Game.find(params['game_id'])
    if params['team_id']
      team = Team.find(params['team_id'])
    else
      team_name = params['team_name']
      normalized_team_name = Team.normalize_name(params['team_name'])
      team = Team.find_by(game: game, normalized_name: normalized_team_name)
      unless team
        team = Team.create(game: game, name: team_name)
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
    @game = Game.find(params['game_id'])
    @team = @current_user.team(@game)
  end

  def leave_team
    @game = Game.find(params['game_id'])
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
  end

  ##################################################################
  # post-game: show leaderboard and slideshow
  ##################################################################

  def leaderboard
  end
end

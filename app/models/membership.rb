class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  belongs_to :game

  after_initialize :init

  def init
    self.is_admin = false if self.is_admin.nil?
  end

  def team_name
    if team.nil?
      return ''
    else
      return team.name
    end
  end

  def team_name=(new_team_name)
    t = Team.first(conditions: {game_id: game.id, name: new_team_name})
    if t.nil?
      t = Team.create!(game_id: game.id, name: new_team_name)
    end
    self.team = t
  end
end

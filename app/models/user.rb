class User < ActiveRecord::Base
  has_many :authorizations
  validates :name, :email, :presence => true

  has_many :registrations
  has_many :teams, :through => :registrations
  has_many :games, :through => :registrations

  default_scope { order(name: :asc) }

  def next_game
    games.where('ends_at > ?', Time.now).order(:starts_at).first
  end

  def add_provider(auth_hash)
    # Check if the provider already exists, so we don't add it twice
    unless authorizations.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
      Authorization.create :user => self, :provider => auth_hash["provider"], :uid => auth_hash["uid"]
    end
  end

  def team(game=next_game)
    membership(game).try(:team)
  end

  def membership(game=next_game)
    Registration.find_by_user_id_and_game_id(self.id, game.id)
  end

  def set_team(team)
    game = team.game
    current_membership = membership(game)
    if current_membership
      current_membership.update_attributes!(team_id: team.id)
    else
      current_membership = Registration.create!(game: game, team: team, user: self)
    end
  end
end

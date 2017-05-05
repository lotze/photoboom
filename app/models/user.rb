class User < ActiveRecord::Base
  has_many :authorizations
  validates :name, :email, :presence => true

  has_many :memberships
  has_many :teams, :through => :memberships
  has_many :games, :through => :teams

  default_scope { order(name: :asc) }

  def add_provider(auth_hash)
    # Check if the provider already exists, so we don't add it twice
    unless authorizations.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
      Authorization.create :user => self, :provider => auth_hash["provider"], :uid => auth_hash["uid"]
    end
  end

  def team(game=Game.default_game)
    Membership.find_by_user_id_and_game_id(self.id, game.id).try(:team)
  end

  def set_team(team)
    current_membership = membership_in(team.game)
    current_membership.destroy if current_membership
    Membership.create!(game: game, team: team, user: self)
  end
end

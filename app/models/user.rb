class User < ActiveRecord::Base
  has_many :authorizations
  validates :name, :email, :presence => true

  has_many :memberships
  has_many :teams, :through => :memberships
  has_many :games, :through => :teams

  def add_provider(auth_hash)
    # Check if the provider already exists, so we don't add it twice
    unless authorizations.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
      Authorization.create :user => self, :provider => auth_hash["provider"], :uid => auth_hash["uid"]
    end
  end

  def membership_in(game)
    Membership.find_by_user_id_and_game_id(self.id, game.id)
  end
end

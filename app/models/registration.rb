class Registration < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  belongs_to :game

  validates :agree_waiver, acceptance: true
  validates :agree_photo, acceptance: true
  validates :legal_name, presence: true

  after_initialize :empty_admin
  def empty_admin
    self.is_admin = false if self.is_admin.nil?
  end

  after_create :update_photos
  before_save :update_photos, if: :team_id_changed?
  def update_photos
    return unless team
    Rails.logger.info("Updating photos for #{user.name} in #{game.name} to #{team.name}!")
    photos = Photo.where(user: user, game: game)
    photos.update_all(team_id: team.id)
  end

  def team_name
    if team.nil?
      return ''
    else
      return team.name
    end
  end

  def team_name=(new_team_name)
    normalized_name = Team.normalize_name(new_team_name)
    t = Team.where(game_id: game.id, normalized_name: normalized_name).first
    if t.nil?
      t = Team.create!(game_id: game.id, name: new_team_name)
    end
    self.team = t
  end
end

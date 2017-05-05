class Mission < ActiveRecord::Base
  has_attached_file :avatar, styles: {thumb: "100x100#"}
  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  # hack for single-game
  before_validation :set_game
  def set_game
    self['game_id'] = Game.default_game_id
  end

  # default to 10 points
  before_validation :set_points
  def set_points
    self['points'] = 10 unless self['points']
  end
end

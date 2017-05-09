class Mission < ActiveRecord::Base
  belongs_to :game

  default_scope { order(codenum: :asc) }

  has_attached_file :avatar, styles: {thumb: "100x100#"}
  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  # hack for single-game
  before_validation :set_game
  def set_game
    self['game_id'] = Game.default_game_id
  end

  # make sure we have a unique codenum
  before_validation :set_codenum
  def set_codenum
    unless self['codenum'] && self['codenum'] > 0
      self['codenum'] = self.game.missions.map(&:codenum).max + 1
    end
  end

  # default to 10 points
  before_validation :set_points
  def set_points
    self['points'] = 10 unless self['points']
  end

  def to_s
    if codenum
      "#{codenum}: #{name}"
    else
      name
    end
  end
end

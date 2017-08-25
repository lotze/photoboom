class Mission < ActiveRecord::Base
  belongs_to :game
  validates :game_id, presence: true
  has_many :photos, dependent: :destroy

  default_scope { order(codenum: :asc) }

  has_attached_file :avatar, styles: {thumb: "100x100#"}, preserve_files: false
  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  before_validation :set_normalized_name
  def set_normalized_name
    self['normalized_name'] = Team.normalize_name(self['name'])
  end

  # make sure we have a unique codenum
  before_validation :set_codenum
  def set_codenum
    unless self['codenum'] && self['codenum'] > 0
      self['codenum'] = (self.game.missions.map(&:codenum).max || 0) + 1
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

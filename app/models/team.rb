class Team < ActiveRecord::Base
  belongs_to :game
  has_many :registrations
  has_many :users, :through => :registrations
  validates_uniqueness_of :normalized_name, scope: :game_id

  before_validation :set_normalized_name
  def set_normalized_name
    self['normalized_name'] = Team.normalize_name(self['name'])
  end

  def formatted_name
    if name =~ /team/i
      return name
    else
      return "Team '#{name}'"
    end
  end

  def self.normalize_name(name)
    return nil unless name
    normalized_name = name[0..254]
    normalized_name = normalized_name.gsub(/[^0-9a-zA-Z !@#$%^&*()\[\]\-_\.,<>{}|\\\/\?=\+:;~`]/, '')
    normalized_name = normalized_name.downcase
    normalized_name = normalized_name[0..40]
    normalized_name = normalized_name.gsub(/[^0-9a-zA-Z]/, '')
  end
end

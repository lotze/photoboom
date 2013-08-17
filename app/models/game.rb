class Game < ActiveRecord::Base
  belongs_to :organizer, :class_name => 'User'
  has_many :teams
  has_many :users, :through => :teams

  scope :public, -> { where(is_public: false) }

  after_initialize :init

  validates :name,:presence => true

  def init
    self.name ||= ''
    now_time = Time.now()
    self.starts_at ||= now_time + 1.day - now_time.min.minutes - now_time.sec.seconds
    self.ends_at ||= self.starts_at + 3.hours
    self.voting_ends_at ||= self.ends_at + 1.day
    self.cost ||= 0
    self.currency ||= 'USD'
    self.is_public = true if self.is_public.nil?
    self.min_team_size ||= 3
    self.max_team_size ||= 6
  end

  def team_names
    self.teams.map {|t| t.name}
  end

  def to_s
    return self.name
  end
end

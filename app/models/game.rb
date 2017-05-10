class Game < ActiveRecord::Base
  belongs_to :organizer, :class_name => 'User'
  has_many :teams
  has_many :users, :through => :teams
  has_many :missions
  has_many :photos

  scope :publicly_available, -> { where(is_public: true) }

  after_initialize :init

  validates :name, :presence => true

  has_attached_file :zip_file
  validates_attachment_content_type :zip_file, :content_type => ["application/zip", "application/x-zip", "application/x-zip-compressed"]

  # default game id to 1
  def Game.default_game_id
    1
  end

  def Game.default_game
    Game.find(Game.default_game_id)
  end

  def init
    self.name ||= ''
    now_time = Time.now()
    self.starts_at ||= now_time + 1.day - now_time.min.minutes - now_time.sec.seconds
    self.ends_at ||= self.starts_at + 3.hours
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

  def time_remaining
    if upcoming?
      return self.starts_at - Time.now
    elsif in_progress?
      return self.ends_at - Time.now
    else
      return nil
    end
  end

  def upcoming?
    Time.now < self.starts_at
  end

  def in_progress?
    Time.now >= self.starts_at && Time.now < self.ends_at
  end

  def over?
    Time.now >= self.ends_at
  end

  def long_over?
    Time.now >= self.ends_at + 1.hour
  end

  def make_zip_file
    require 'open-uri'
    photos = Photo.where(game: self, rejected: false).includes(:user).includes(:mission)
    photo_dir = Dir.mktmpdir('photos')

    files = []
    photos.each do |photo|
      mission = photo.mission
      # download the photo into photo_dir
      filename = "#{photo_dir}/#{photo.team.normalized_name}_#{mission.codenum}_#{photo.created_at.strftime('%Y%m%d%H%M%S')}.#{MIME::Types[photo.photo_content_type].first.extensions.first}"
      if photo.photo.options[:storage] == :filesystem
        FileUtils.copy(photo.photo.path, filename)
      else
        IO.copy_stream(open(photo.photo.url, 'rb'), filename)
      end
      files << filename
    end
    # make zip file
    require 'zip'
    zip_dir = Dir.mktmpdir('zip')
    zip_file_name = "#{zip_dir}/game_#{self.id}.zip"
    Zip::File.open(zip_file_name, Zip::File::CREATE) do |zipfile|
      files.each do |filename|
       # Add the file to the zip
        zipfile.add("game_#{self.id}/#{File.basename(filename)}", filename)
      end
    end
    # upload zip file
    self.zip_file = File.open(zip_file_name, 'r')
    save
  end
end

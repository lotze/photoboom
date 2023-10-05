class Game < ActiveRecord::Base
  belongs_to :organizer, :class_name => 'User'
  has_many :teams, dependent: :destroy
  has_many :registrations
  has_many :users, :through => :registrations
  has_many :missions, dependent: :destroy
  has_many :photos

  scope :publicly_available, -> { where(is_public: true) }
  scope :upcoming, -> { where('starts_at > ?', Time.now) }
  scope :running, -> { where('? BETWEEN starts_at AND ends_at + INTERVAL \'2 minutes\'', Time.now) }

  after_initialize :init

  validates :name, :presence => true
  validates :start_location, :presence => true

  has_attached_file :zip_file
  validates_attachment_content_type :zip_file, :content_type => ["application/zip", "application/x-zip", "application/x-zip-compressed"]

  def is_admin?(user)
    user == organizer
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

  def end_location_string
    end_location || "the end location"
  end

  def contact_string
    contact || organizer.email
  end

  def without_team
    registrations.where(team_id: nil)
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

  def start_time_in_zone
    ActiveSupport::TimeZone.new(timezone).parse(starts_at.to_s)
  end

  def end_time_in_zone
    ActiveSupport::TimeZone.new(timezone).parse(ends_at.to_s)
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
    photos = Photo.where(game: self, rejected: false).includes(:user).includes(:mission).includes(:team)
    photo_dir = Dir.mktmpdir('photos')

    files = []
    photos.each do |photo|
      mission = photo.mission
      # download the photo into photo_dir
      filename = "#{photo_dir}/#{photo.team.normalized_name}_#{mission.codenum}_#{mission.normalized_name}_#{photo.created_at.strftime('%Y%m%d%H%M%S')}_#{photo.id}.#{MIME::Types[photo.photo_content_type].first.extensions.first}"
      if photo.photo.options[:storage] == :filesystem
        FileUtils.copy(photo.photo.path, filename)
      else
        url = photo.photo.url.gsub("%2F", "/")
        unless url =~ /^http/
          url = "http:#{url}"
        end
        IO.copy_stream(URI.open(url, 'rb'), filename)
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

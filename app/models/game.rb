class Game < ActiveRecord::Base
  belongs_to :organizer, :class_name => 'User'
  has_many :teams, dependent: :destroy
  has_many :users, :through => :teams
  has_many :missions, dependent: :destroy
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

  # doesn't work yet, probably because of Inkscape svg weirdness
  # can fix by converting to text (removing flow boxes)
  # maybe use ruby to wrap description, everything else 1 line
  # TODO: convert first page to be page of rules/submission instructions instead of title + missions
  def make_mission_pdf_file
    tmp_dir = Dir.mktmpdir("svg_mission")
    page = 1
    pdf = CombinePDF.new
    while newpage = make_svg_page(page, tmp_dir)
      pdf_file = "#{tmp_dir}/missions_#{"%02d" % page}.pdf"
      Prawn::Document.generate(pdf_file) do
        svg newpage
      end
      pdf << CombinePDF.load(pdf_file)
      page = page + 1
    end
    pdf.save "#{tmp_dir}/missions.pdf"
    Rails.logger.info("stored in #{tmp_dir}/missions.pdf")
  end

  def make_mission_svg_zip_file
    tmp_dir = Dir.mktmpdir("svg_mission")
    page = 1
    svg_pages = []
    while newpage = make_svg_page(page, tmp_dir)
      svg_file = "#{tmp_dir}/missions_#{"%02d" % page}.svg"
      File.open(svg_file, 'w') {|f| f.write(newpage) }
      svg_pages << svg_file
      page = page + 1
    end
    require 'zip'
    zip_file_name = "#{tmp_dir}/game_#{self.id}_missions.zip"
    Zip::File.open(zip_file_name, Zip::File::CREATE) do |zipfile|
      svg_pages.each do |filename|
       # Add the file to the zip
        zipfile.add("game_#{self.id}_missions/#{File.basename(filename)}", filename)
      end
    end
    Rails.logger.info("stored in #{zip_file_name}")
    # TODO: maybe store?
    return zip_file_name
  end

  def make_svg_page(page, svg_dir)
    num_per_page = 14
    title_num = 2
    if page == 1
      template_basename = 'title_mission_template.svg'
      mission_codenums =(1..(num_per_page - title_num)).to_a
    else
      template_basename = 'mission_template.svg'
      start_num = (num_per_page - title_num) + (page - 2) * num_per_page + 1
      end_num = start_num + num_per_page - 1
      mission_codenums =(start_num..end_num).to_a
    end
    printable_missions = missions.where(codenum: mission_codenums)
    return nil if printable_missions.empty?

    # open template; make substitutions; render as svg
    template_file = Rails.root.join('data', template_basename)

    sheet_template = IO.read(template_file)
    sheet_template.sub!('game.name', name)
    sheet_template.sub!('game.date', starts_at.strftime('%Y-%m-%d'))

    printable_missions.each do |mission|
      sheet_template.sub!('mission.codenum', mission.codenum.to_s)
      sheet_template.sub!('mission.name', mission.name)
      sheet_template.sub!('mission.points', mission.points.to_s)
      sheet_template.sub!('mission.description', mission.description)
    end
    # replace any extra mission text fields
    sheet_template.gsub!('mission.codenum: mission.name', '')
    sheet_template.gsub!('Points: mission.points', '')
    sheet_template.gsub!('mission.points points', '')
    sheet_template.gsub!('mission.description', '')

    return sheet_template
  end


  def make_zip_file
    require 'open-uri'
    photos = Photo.where(game: self, rejected: false).includes(:user).includes(:mission)
    photo_dir = Dir.mktmpdir('photos')

    files = []
    photos.each do |photo|
      mission = photo.mission
      # download the photo into photo_dir
      filename = "#{photo_dir}/#{photo.team.normalized_name}_#{mission.codenum}_#{mission.normalized_name}_#{photo.created_at.strftime('%Y%m%d%H%M%S')}_#{photo.id}.#{MIME::Types[photo.photo_content_type].first.extensions.first}"
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

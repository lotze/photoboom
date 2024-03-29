class Photo < ActiveRecord::Base
  belongs_to :game
  belongs_to :mission
  belongs_to :user
  belongs_to :team

  has_attached_file :photo, preserve_files: false,
  styles: {
    thumb: "100x100#",
    slideshow: "2000x2000>" # Make slideshow photos have maximum size of 2000 pixels in any dimension; main use is actually to deal with rotation
  },
  convert_options: {
    thumb: "-quality 75",
    all: "-auto-orient -strip"
  }
  process_in_background :photo, processing_image_url: "/images/:style/processing.jpg"

  after_post_process :extract_dimensions
  def extract_dimensions
    tempfile = photo.queued_for_write[:slideshow]
    unless tempfile.nil?
      geometry = Paperclip::Geometry.from_file(tempfile)
      self.width = geometry.width.to_i
      self.height = geometry.height.to_i
    end
  end

  def update_dimensions
    tempfile = Rails.root.join('tmp').to_s + "/" + self.photo_file_name
    self.photo.copy_to_local_file(nil, tempfile)
    geometry = Paperclip::Geometry.from_file(tempfile)
    self.update(width: geometry.width.to_i, height: geometry.height.to_i)
    File.delete(tempfile)
  end

  def scale_factor(max_width, max_height)
    width_factor = max_width / width.to_f
    height_factor = max_height / height.to_f
    [width_factor, height_factor].min
  end

  def slideshow_width(max_width, max_height)
    begin
      (width * scale_factor(max_width, max_height)).round
    rescue => e
      Rails.logger.warn("Couldn't get a good slideshow width for photo #{self.id}, using 480")
      return 640
    end
  end

  def slideshow_height(max_width, max_height)
    begin
      (height * scale_factor(max_width, max_height)).round
    rescue => e
      Rails.logger.warn("Couldn't get a good slideshow height for photo #{self.id}, using 480")
      return 480
    end
  end

  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def reject!(notes)
    self.update!(rejected: true, reviewed: true)
    # email user to notify
    begin
      NoticeMailer.rejected_photo(self, notes).deliver_later
    rescue => e
      Rails.logger.warn("Could not email for rejecting photo #{self}: #{e}")
    end
  end

  def accept!(notes)
    if rejected
      # email user to notify
      begin
        NoticeMailer.unrejected_photo(self, notes).deliver_later
      rescue => e
        Rails.logger.warn("Could not email for unrejecting photo #{self}: #{e}")
      end
    end

    self.update!(rejected: false, reviewed: true)
  end
end

class Photo < ActiveRecord::Base
  belongs_to :game
  belongs_to :mission
  belongs_to :user
  belongs_to :team

  # "slideshow" is capped at 2000px on its longest side; its main purpose is
  # actually to deal with EXIF rotation via auto_orient, not resizing.
  has_one_attached :photo do |attachable|
    attachable.variant :thumb, auto_orient: true, resize_to_fill: [100, 100], strip: true, quality: 75, preprocessed: true
    attachable.variant :slideshow, auto_orient: true, resize_to_limit: [2000, 2000], strip: true, preprocessed: true
  end

  after_create_commit :extract_dimensions, if: -> { photo.attached? }

  def extract_dimensions
    ExtractPhotoDimensionsJob.perform_later(self)
  end

  # Width/height are read off the processed "slideshow" variant (rather than
  # the original blob) so they reflect the size after EXIF auto-orientation.
  def update_dimensions
    image = MiniMagick::Image.read(photo.variant(:slideshow).processed.download)
    self.update(width: image.width, height: image.height)
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

  ACCEPTABLE_CONTENT_TYPES = ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  validate :acceptable_photo_content_type

  def acceptable_photo_content_type
    return unless photo.attached?
    unless ACCEPTABLE_CONTENT_TYPES.include?(photo.content_type)
      errors.add(:photo, "must be a JPEG, PNG, or GIF image")
    end
  end

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

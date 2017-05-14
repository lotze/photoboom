class Photo < ActiveRecord::Base
  belongs_to :game
  belongs_to :mission
  belongs_to :user
  belongs_to :team

  has_attached_file :photo, preserve_files: false,
  styles: {
    thumb: "100x100#",
    slideshow: "500x750>"
  },
  convert_options: {
    thumb: "-quality 75 -strip",
    slideshow: "-strip"
  }

  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def reject!(notes)
    self.update_attributes!(rejected: true)
    # email user to notify
    begin
      NoticeMailer.rejected_photo(self, notes).deliver_now
    rescue => e
      Rails.logger.warn("Could not email for rejecting photo #{self}: #{e}")
    end
  end
end

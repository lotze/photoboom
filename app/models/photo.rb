class Photo < ActiveRecord::Base
  belongs_to :game
  belongs_to :mission
  belongs_to :user
  belongs_to :team

  has_attached_file :photo, styles: {thumb: "100x100#"}
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

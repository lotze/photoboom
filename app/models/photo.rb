class Photo < ActiveRecord::Base
  belongs_to :game
  belongs_to :mission
  belongs_to :user

  has_attached_file :photo, styles: {thumb: "100x100#"}
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end

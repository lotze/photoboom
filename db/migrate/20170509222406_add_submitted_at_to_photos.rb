class AddSubmittedAtToPhotos < ActiveRecord::Migration[5.1]
  def change
    add_column :photos, :submitted_at, :datetime
  end
end

class AddReviewedFlagToPhotos < ActiveRecord::Migration[5.1]
  def change
  	add_column :photos, :reviewed, :boolean, null: false, default: false
  end
end

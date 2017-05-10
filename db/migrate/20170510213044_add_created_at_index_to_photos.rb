class AddCreatedAtIndexToPhotos < ActiveRecord::Migration[5.1]
  def change
    add_index :photos, [:game_id, :created_at]
  end
end

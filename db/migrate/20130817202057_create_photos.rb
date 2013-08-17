class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :mission_id
      t.string :resource_location
      t.float :rating

      t.timestamps
      t.index [:user_id, :rating]
      t.index [:game_id, :rating]
      t.index [:mission_id, :rating]
    end
  end
end

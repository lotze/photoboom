class RemoveUnusedRating < ActiveRecord::Migration[5.1]
  def change
    remove_column :games, :voting_ends_at
    remove_column :games, :cost
    remove_column :games, :currency

    remove_index :photos, [:game_id, :rating]
    remove_index :photos, [:mission_id, :rating]
    remove_index :photos, [:user_id, :rating]
    remove_column :photos, :rating
    add_index :photos, :mission_id
  end
end

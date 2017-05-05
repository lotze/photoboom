class AddFieldsToMissionsAndPhotos < ActiveRecord::Migration[5.1]
  def change
    # # set default game_id for teams, memberships and photos to 1
    # change_column :teams, :game_id, :integer, null: false, default: 1
    # change_column :memberships, :game_id, :integer, null: false, default: 1
    # change_column :photos, :game_id, :integer, null: false, default: 1

    add_column :missions, :name, :string
    add_column :missions, :priority, :integer
    add_attachment :missions, :avatar

    add_column :photos, :bonus_points, :integer
    add_column :photos, :notes, :string
    add_column :photos, :rejected, :boolean, null: false, default: false
    add_index :photos, [:game_id, :rejected]
    remove_column :photos, :resource_location, :string
    add_attachment :photos, :photo

    remove_index :memberships, column: [:game_id, :user_id]
    add_index :memberships, [:game_id, :user_id], unique: true
  end
end

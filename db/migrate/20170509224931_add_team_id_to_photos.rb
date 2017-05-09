class AddTeamIdToPhotos < ActiveRecord::Migration[5.1]
  def change
    add_column :photos, :team_id, :integer
    add_index :photos, [:team_id, :rejected]
  end
end

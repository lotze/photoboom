class AddNormalizedNameToMissions < ActiveRecord::Migration[5.1]
  def change
    add_column :missions, :normalized_name, :string
    add_index :missions, [:game_id, :normalized_name]
  end
end

class AddNormalizedTeamName < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :normalized_name, :string, null: false, unique: true
  end
end

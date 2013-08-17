class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :game_id
      t.string :name

      t.timestamps
      t.index [:game_id, :name]
    end
  end
end

class CreateMissions < ActiveRecord::Migration[4.2]
  def change
    create_table :missions do |t|
      t.integer :game_id
      t.string :description
      t.integer :points

      t.timestamps
      t.index :game_id
    end
  end
end

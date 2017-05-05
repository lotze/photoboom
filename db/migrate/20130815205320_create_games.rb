class CreateGames < ActiveRecord::Migration[4.2]
  def change
    create_table :games do |t|
      t.integer :organizer_id, :null => false
      t.string :name, :null => false
      t.datetime :starts_at, :null => false
      t.datetime :ends_at, :null => false
      t.datetime :voting_ends_at, :null => false
      t.integer :cost, :null => false
      t.string :currency, :null => false
      t.boolean :is_public, :null => false
      t.integer :min_team_size, :null => false
      t.integer :max_team_size, :null => false

      t.timestamps
      t.index :organizer_id
      t.index [:is_public, :starts_at]
    end
  end
end

class CreateMemberships < ActiveRecord::Migration[4.2]
  def change
    create_table :memberships do |t|
      t.integer :team_id, :null => false
      t.integer :game_id, :null => false
      t.integer :user_id, :null => false
      t.boolean :is_admin, :null => false

      t.timestamps
      t.index :user_id
      t.index [:game_id, :user_id]
      t.index :team_id
    end
  end
end

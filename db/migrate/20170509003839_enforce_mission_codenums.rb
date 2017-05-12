class EnforceMissionCodenums < ActiveRecord::Migration[5.1]
  def change
    remove_column :missions, :priority, :integer
    add_column :missions, :codenum, :integer, null: false, default: 0
    remove_index :missions, :game_id
    add_index :missions, [:game_id, :codenum] #, unique: true
  end
end

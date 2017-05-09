class NonuniqueCodenums < ActiveRecord::Migration[5.1]
  def change
    remove_index :missions, [:game_id, :codenum]
    add_index :missions, [:game_id, :codenum]
  end
end

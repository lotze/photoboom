class CreateAuthorizations < ActiveRecord::Migration[4.2]
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.string :uid
      t.integer :user_id

      t.timestamps
    end
    add_index :authorizations, :user_id
    add_index :authorizations, [:provider, :uid]
  end
end

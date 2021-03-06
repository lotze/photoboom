class CreateIdentities < ActiveRecord::Migration[4.2]
  def change
    create_table :identities do |t|
      t.string :email
      t.string :password_digest

      t.timestamps
      t.index :email
    end
  end
end

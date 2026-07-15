class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :game, null: false, foreign_key: true
      t.string :tier, null: false
      t.integer :amount_cents, null: false
      t.string :stripe_checkout_session_id
      t.string :stripe_payment_intent_id
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end
    add_index :payments, :stripe_checkout_session_id, unique: true
  end
end

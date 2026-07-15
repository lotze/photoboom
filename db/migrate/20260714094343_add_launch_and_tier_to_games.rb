class AddLaunchAndTierToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :tier, :string, null: false, default: 'free'
    add_column :games, :launched_at, :datetime
    add_column :games, :stripe_checkout_session_id, :string
  end
end

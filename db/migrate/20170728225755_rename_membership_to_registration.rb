class RenameMembershipToRegistration < ActiveRecord::Migration[5.1]
  def change
    rename_table :memberships, :registrations
    add_column :registrations, :payment_token, :string
    # Registrations.each {|r| r.update_attributes!(game_id: r.team.game_id)}
  end
end

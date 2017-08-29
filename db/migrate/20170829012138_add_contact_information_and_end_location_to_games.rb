class AddContactInformationAndEndLocationToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :contact, :string
    add_column :games, :end_location, :string
  end
end

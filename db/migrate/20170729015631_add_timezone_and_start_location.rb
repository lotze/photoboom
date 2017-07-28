class AddTimezoneAndStartLocation < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :timezone, :string
    add_column :games, :start_location, :string
  end
end

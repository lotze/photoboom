class AddZipFileToGame < ActiveRecord::Migration[5.1]
  def change
    add_attachment :games, :zip_file
  end
end

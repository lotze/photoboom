class AddMissionPdfLinkToGame < ActiveRecord::Migration[5.1]
  def change
    add_attachment :games, :mission_pdf
  end
end

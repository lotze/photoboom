class AddWaiverAndReleaseInfo < ActiveRecord::Migration[5.1]
  def change
    remove_attachment :missions, :avatar
    add_column :registrations, :legal_name, :string
    add_column :registrations, :agree_waiver, :boolean
    add_column :registrations, :agree_photo, :boolean
  end
end

# In production, run `rake paperclip:migrate_to_active_storage` (see
# lib/tasks/paperclip_migration.rake) and verify attachments resolve BEFORE
# running this migration -- it drops the columns that task reads from.
class RemovePaperclipColumnsFromGamesAndPhotos < ActiveRecord::Migration[8.1]
  def change
    remove_column :games, :zip_file_file_name, :string
    remove_column :games, :zip_file_content_type, :string
    remove_column :games, :zip_file_file_size, :integer
    remove_column :games, :zip_file_updated_at, :datetime

    remove_column :photos, :photo_file_name, :string
    remove_column :photos, :photo_content_type, :string
    remove_column :photos, :photo_file_size, :integer
    remove_column :photos, :photo_updated_at, :datetime
  end
end

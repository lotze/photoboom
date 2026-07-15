# One-time data migration from Paperclip to ActiveStorage.
#
# Paperclip's legacy `*_file_name`/`*_content_type`/`*_file_size`/`*_updated_at`
# columns are still present on `games` and `photos` at this point (they aren't
# dropped until db/migrate/*_remove_paperclip_columns_from_games_and_photos.rb
# runs). This task reads those columns and the existing S3 objects Paperclip
# already wrote, and creates ActiveStorage::Blob/Attachment records that point
# at the *same* S3 keys -- no re-upload, just a read to compute a checksum.
#
# Run this in production BEFORE running the "remove paperclip columns"
# migration, and verify attachments resolve (e.g. spot check a handful of
# `Photo.find(id).photo.url` / `Game.find(id).zip_file.url`) before dropping
# the legacy columns.
#
#   heroku run rake paperclip:migrate_to_active_storage
module PaperclipMigration
  module_function

  def s3_key(class_name, attachment_name, id, style, filename)
    id_partition = format("%09d", id).scan(/\d{3}/).join("/")
    "#{class_name}/#{attachment_name}/#{id_partition}/#{style}/#{filename}"
  end

  def checksum_for(service, key)
    # MD5 checksum, base64-encoded, the format ActiveStorage expects.
    digest = Digest::MD5.new
    service.download(key) { |chunk| digest << chunk }
    digest.base64digest
  end

  def migrate_attachment(record, attachment_name, class_name, file_name, content_type, file_size)
    return if file_name.blank?
    return if record.public_send(attachment_name).attached?

    service = ActiveStorage::Blob.service
    key = s3_key(class_name, attachment_name, record.id, "original", file_name)

    unless service.exist?(key)
      puts "  [skip] #{class_name}##{record.id} #{attachment_name}: no object at #{key}"
      return
    end

    blob = ActiveStorage::Blob.create!(
      key: key,
      filename: file_name,
      content_type: content_type,
      byte_size: file_size,
      checksum: checksum_for(service, key)
    )
    record.public_send("#{attachment_name}_attachment=", ActiveStorage::Attachment.new(
      name: attachment_name, record: record, blob: blob
    ))
    record.save!(validate: false)
    puts "  [ok]   #{class_name}##{record.id} #{attachment_name} -> #{key}"
  end
end

namespace :paperclip do
  desc "Backfill ActiveStorage blobs/attachments from existing Paperclip S3 objects"
  task migrate_to_active_storage: :environment do
    puts "Migrating Photo#photo..."
    Photo.find_each do |photo|
      PaperclipMigration.migrate_attachment(photo, "photo", "photos", photo.read_attribute(:photo_file_name),
        photo.read_attribute(:photo_content_type), photo.read_attribute(:photo_file_size))
    end

    puts "Migrating Game#zip_file..."
    Game.find_each do |game|
      PaperclipMigration.migrate_attachment(game, "zip_file", "games", game.read_attribute(:zip_file_file_name),
        game.read_attribute(:zip_file_content_type), game.read_attribute(:zip_file_file_size))
    end

    puts "Done."
  end
end

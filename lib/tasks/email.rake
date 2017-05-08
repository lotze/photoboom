namespace :email do
  task :update_photos => :environment do
    email_updater = EmailUpdater.new
    email_updater.update
  end
end

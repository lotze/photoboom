namespace :email do
  task :update_photos => :environment do
    puts("Performing an email update; rake")
    EmailUpdater.perform
  end
end

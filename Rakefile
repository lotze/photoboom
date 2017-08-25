require 'resque/tasks'
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

# needed for Resque: https://github.com/resque/resque/issues/1265
task 'resque:setup' => :environment

Photoboom::Application.load_tasks

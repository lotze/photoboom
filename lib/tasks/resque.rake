# Resque tasks
require 'resque/tasks'
require 'resque/scheduler/tasks'

task "resque:setup" => :environment
task "resque:scheduler_setup" => :environment

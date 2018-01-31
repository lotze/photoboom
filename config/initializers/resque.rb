if ENV.include?('REDIS_URL')
  Resque.logger.level = Logger::DEBUG
  Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
  Resque.schedule = YAML.load_file(File.join(File.dirname(__FILE__), '../resque_schedule.yml'))
end
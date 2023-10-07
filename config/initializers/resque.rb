# Note: may need to set RAILS_RESQUE_REDIS as well as REDIS_URL
# https://stackoverflow.com/questions/42388458/redis-tries-to-connect-to-localhost-on-heroku-instead-of-redis-url
if ENV.include?('REDIS_URL')
  Resque.logger.level = Logger::DEBUG
  Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
  Resque.schedule = YAML.load_file(File.join(File.dirname(__FILE__), '../resque_schedule.yml'))
end
Resque.logger.level = Logger::DEBUG

Resque.schedule = YAML.load_file(File.join(File.dirname(__FILE__), '../resque_schedule.yml'))
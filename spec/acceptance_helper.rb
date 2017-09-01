ENV['ACCEPTANCE'] = 'true'
require 'coverage_helper'
require 'rails_helper'

require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'database_cleaner'

require 'webmock/rspec'

SimpleCov.command_name 'spec:acceptance' if RUBY_PLATFORM != 'java'

Capybara.server_port = 3001

Capybara.default_max_wait_time = 5
Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  config.include Capybara::DSL

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.before(:all) do
    init_capybara
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  def init_capybara
    visit '/'
  end
end

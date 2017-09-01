require 'coverage_helper'
require 'rails_helper'
require 'fdoc/spec_watcher'
require 'webmock/rspec'

SimpleCov.command_name 'spec:integration' if RUBY_PLATFORM != 'java'

FAKE_TOKEN = OAuth2::AccessToken.new(
    OAuth2::Client.new(ENV['COMPEER_CLIENT_AUTH_ID'],
                       ENV['COMPEER_CLIENT_AUTH_SECRET'],
                       site: "#{ENV['SSO_SITE']}",
                       token_url: "/o/token/",
                       authorize_url: "/o/authorize/"),
    'whatever_token'
)

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    # DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.render_views
end


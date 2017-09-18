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

def log_in_as_oauth_user(user = FactoryGirl.create(:user))
    # mock omniauth responses from SSO server
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new
    OmniAuth.config.add_mock(:google_oauth2, {
        provider: :google_oauth2,
        info: {
            email: user.email,
            name: user.name
        },
        credentials: {
            token: 'fake_token',
            refresh_token: 'fake_refresh_token'
        }
    })
    visit('/auth/google_oauth2')
    return user
  end

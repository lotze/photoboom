ENV['ACCEPTANCE'] = 'true'
require 'coverage_helper'
require 'rails_helper'

require 'capybara/rails'
require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless=new')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--window-size=1400,1400')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
Capybara.javascript_driver = :selenium_chrome_headless

require 'database_cleaner'

require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true, allow: [
    'localhost',
    '127.0.0.1:3001'
])

SimpleCov.command_name 'spec:acceptance' if RUBY_PLATFORM != 'java'

Capybara.server = :webrick
Capybara.server_port = 3001
Capybara.default_max_wait_time = 5

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
  end
end

def log_in_as_oauth_user(user = FactoryBot.create(:user))
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

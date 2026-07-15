ENV['ACCEPTANCE'] = 'true'
require 'coverage_helper'
require 'rails_helper'

require 'capybara/rails'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'tmpdir'

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless=new')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--window-size=1400,1400')
  options.add_argument('--remote-allow-origins=*')
  options.add_argument("--user-data-dir=#{Dir.mktmpdir('chrome-profile')}")
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 120
  client.open_timeout = 120
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options, http_client: client)
end
Capybara.javascript_driver = :selenium_chrome_headless

require 'database_cleaner'

require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true, allow: [
    'localhost',
    '127.0.0.1:3001'
])

SimpleCov.command_name 'spec:acceptance' if RUBY_PLATFORM != 'java'

Capybara.server = :puma, { Silent: true }
Capybara.server_port = 3001
Capybara.default_max_wait_time = 10

RSpec.configure do |config|
  config.include Capybara::DSL

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  # Capybara.reset_sessions! (registered by requiring 'capybara/rspec') resets
  # every open session in one loop; if a prior js: true example's browser
  # session is hung, that loop raises partway through and any rack_test
  # session's cookies never get cleared, leaking a logged-in user into the
  # next example. Explicitly reset just the current (non-js) session here,
  # which is always local/instant, so non-js examples are never contaminated
  # by a stuck JS session.
  config.before(:each) do
    if Capybara.current_driver != Capybara.javascript_driver
      begin
        Capybara.current_session.reset!
      rescue => e
      end
    end
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
        uid: "test-uid-#{user.id}",
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

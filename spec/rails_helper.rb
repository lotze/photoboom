ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/mocks'
require 'factory_bot_rails'

RSpec.configure do |config|
  # From rspec/rails/example
  def config.escaped_path(*parts)
    Regexp.compile(parts.join('[\\\/]') + '[\\\/]')
  end

  config.backtrace_exclusion_patterns << %r{vendor/}
  config.backtrace_exclusion_patterns << %r{lib/rspec/rails/}

  config.disable_monkey_patching!

  config.include FactoryBot::Syntax::Methods
end

FactoryBot::SyntaxRunner.class_eval do
  include RSpec::Mocks::ExampleMethods
end
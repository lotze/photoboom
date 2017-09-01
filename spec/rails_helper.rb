ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'

RSpec.configure do |config|
  # From rspec/rails/example
  def config.escaped_path(*parts)
    Regexp.compile(parts.join('[\\\/]') + '[\\\/]')
  end

  config.backtrace_exclusion_patterns << %r{vendor/}
  config.backtrace_exclusion_patterns << %r{lib/rspec/rails/}

  config.disable_monkey_patching!

  config.include FactoryGirl::Syntax::Methods
end

FactoryGirl::SyntaxRunner.class_eval do
  include RSpec::Mocks::ExampleMethods
end
require 'coverage_helper'

SimpleCov.command_name 'spec:unit' if RUBY_PLATFORM != 'java'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.mock_with :rspec

  # config.before(:suite) do
  #   if Object.const_defined?('Rails')
  #     fail 'The Rails environment should not be loaded for unit tests.'
  #   end
  # end
end

require 'factory_bot'
FactoryBot.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
#FactoryBot.find_definitions
include FactoryBot::Syntax::Methods
FactoryBot::SyntaxRunner.class_eval do
  include RSpec::Mocks::ExampleMethods
end

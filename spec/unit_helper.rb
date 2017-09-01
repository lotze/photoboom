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

require 'factory_girl'
FactoryGirl.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
#FactoryGirl.find_definitions
include FactoryGirl::Syntax::Methods
FactoryGirl::SyntaxRunner.class_eval do
  include RSpec::Mocks::ExampleMethods
end

require 'coverage_helper'

SimpleCov.command_name 'spec:lint' if RUBY_PLATFORM != 'java'

RSpec.configure(&:disable_monkey_patching!)

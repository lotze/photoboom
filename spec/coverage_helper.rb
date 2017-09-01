if ENV['COVERAGE'] != '0' && RUBY_PLATFORM != 'java'
  require 'simplecov'

  class SimpleCov::Formatter::MergedFormatter
    def format(result)
      SimpleCov::Formatter::HTMLFormatter.new.format(result)
      coverage_file = File.join(
        File.dirname(__FILE__),
        '..',
        '/coverage/covered_percent',
      )
      File.open(coverage_file, 'w') do |f|
        f.puts result.source_files.covered_percent.to_i
      end
    end
  end

  SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter

  SimpleCov.start 'rails' do
    add_filter '/vendor/'
  end
end

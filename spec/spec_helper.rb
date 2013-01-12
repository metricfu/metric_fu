require 'rubygems'
require 'rspec/autorun'
require 'date'
require 'construct'

require File.expand_path File.join(File.dirname(__FILE__), '/../lib/metric_fu.rb')
include MetricFu

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[MetricFu.root_dir + "/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  # :suite after/before all specs
  # :each ever describe block
  # :all ever it block

  config.after(:suite) do
    cleanup_test_files
  end
end

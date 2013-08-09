if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-rcov-text'
  SimpleCov.formatter = SimpleCov::Formatter::RcovTextFormatter
  SimpleCov.start
end

require 'rspec/autorun'
require 'date'
require 'construct'
require 'json'

# add lib to the load path just like rubygems does
$:.push File.expand_path("../../lib", __FILE__)
require 'metric_fu'
include MetricFu
def mf_log(msg); mf_debug(msg); end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[MetricFu.root_dir + "/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  # :suite after/before all specs
  # :each ever describe block
  # :all ever it block

  config.order = 'random'

  config.after(:suite) do
    cleanup_test_files
  end

  config.after(:each) do
    MetricFu.reset
  end
end

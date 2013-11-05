require 'rspec/autorun'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.coverage_dir("tmp/metric_fu/output/coverage")
  formatters = [SimpleCov::Formatter::HTMLFormatter]
  begin
    puts '[COVERAGE] Running with SimpleCov HTML Formatter'
    require 'simplecov-rcov-text'
    formatters << SimpleCov::Formatter::RcovTextFormatter
    puts '[COVERAGE] Running with SimpleCov Rcov Formatter'
  rescue LoadError
    puts '[COVERAGE] SimpleCov Rcov formatter could not be loaded'
  end
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[ *formatters ]
  SimpleCov.start
end

require 'date'
require 'construct'
require 'json'
require 'pry-nav'

# add lib to the load path just like rubygems does
$:.unshift File.expand_path("../../lib", __FILE__)
require 'metric_fu'
include MetricFu
def mf_log(msg); mf_debug(msg); end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[MetricFu.root_dir + "/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.filter_run_excluding :slow unless ENV["SLOW_SPECS"]
  config.fail_fast = ENV.include?('FAIL_FAST')
  config.order = 'random'

  # :suite after/before all specs
  # :each every describe block
  # :all every it block

  def run_dir
    File.expand_path('dummy', File.dirname(__FILE__))
  end

  config.before(:suite) do
    MetricFu.run_dir = run_dir
  end

  config.after(:suite) do
    cleanup_fs
  end

  config.after(:each) do
    MetricFu.reset
  end
end

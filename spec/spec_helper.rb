# add lib to the load path just like rubygems does
$:.unshift File.expand_path("../../lib", __FILE__)
require "simplecov"

require "date"
require "test_construct"
require "json"
require "pry-nav"

require "metric_fu"
include MetricFu
def mf_log(msg); mf_debug(msg); end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[MetricFu.root_dir + "/spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  # Skip specs tagged `:slow` unless SLOW_SPECS is set
  config.filter_run_excluding :slow unless ENV["SLOW_SPECS"]
  # End specs on first failure if FAIL_FAST is set
  config.fail_fast = ENV.include?("FAIL_FAST")
  config.order = :rand
  config.color = true
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  # :suite after/before all specs
  # :each every describe block
  # :all every it block

  def dummy_dir
    File.expand_path("dummy", File.dirname(__FILE__))
  end

  config.before(:suite) do
    MetricFu.run_dir = dummy_dir
  end

  config.after(:suite) do
    cleanup_fs
  end

  config.append_after do
    MetricFu.reset
  end
end

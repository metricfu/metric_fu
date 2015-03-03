# https://github.com/colszowka/simplecov#using-simplecov-for-centralized-config
# see https://github.com/colszowka/simplecov/blob/master/lib/simplecov/defaults.rb
# vim: set ft=ruby
@minimum_coverage = ENV.fetch("COVERAGE_MINIMUM") { 87.8 }.to_f.round(2)
if SimpleCov.respond_to?(:profiles)
  SimpleCov.profiles
else
  SimpleCov.adapters
end.define 'metric_fu' do
  if defined?(load_profile)
    load_profile  'test_frameworks'
  else
    load_adapter 'test_frameworks'
  end

  add_group "Cli",             "lib/metric_fu/cli"
  add_group "Data Structures", "lib/metric_fu/data_structures"
  add_group "Formatters",      "lib/metric_fu/formatter"
  add_group "Hotspots",        "lib/metric_fu/metrics/hotspots"
  add_group "Metrics",         "lib/metric_fu/metrics"
  add_group "Reporters",       "lib/metric_fu/reporting"
  add_group "Templates",       "lib/metric_fu/templates"

  add_group "Long files" do |src_file|
    src_file.lines.count > 100
  end
  class MaxLinesFilter < SimpleCov::Filter
    def matches?(source_file)
      source_file.lines.count < filter_argument
    end
  end
  add_group "Short files", MaxLinesFilter.new(5)

  # Exclude these paths from analysis
  add_filter 'bundle'
  add_filter 'vendor/bundle'
  add_filter 'bin'
  add_filter 'lib/metric_fu/tasks'

  # https://github.com/colszowka/simplecov/blob/v0.9.1/lib/simplecov/defaults.rb#L60
  # minimum_coverage @minimum_coverage
end

## RUN SIMPLECOV
if defined?(@running_tests)
  @running_tests = false
else
  @running_tests = caller.any? {|line| line =~ /exe\/rspec/ }
end
if ENV["COVERAGE"] =~ /\Atrue\z/i
  puts "[COVERAGE] Running with SimpleCov HTML Formatter"
  formatters = [SimpleCov::Formatter::HTMLFormatter]
  begin
    puts '[COVERAGE] Running with SimpleCov HTML Formatter'
    require 'metric_fu/metrics/rcov/simplecov_formatter'
    formatters << SimpleCov::Formatter::MetricFu
    puts '[COVERAGE] Running with SimpleCov MetricFu Formatter'
  rescue LoadError
    puts '[COVERAGE] SimpleCov MetricFu formatter could not be loaded'
  end
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[ *formatters ]
  SimpleCov.start "metric_fu" if @running_tests
else
  SimpleCov.formatters = []
end
SimpleCov.at_exit do
  SimpleCov.result.format!
  percent = Float(SimpleCov.result.covered_percent)
  if percent < @minimum_coverage
    abort "Spec coverage was not high enough: #{percent.round(2)} is < #{@minimum_coverage}%"
  else
    puts "Nice job! Spec coverage is still above #{@minimum_coverage}%"
  end
end

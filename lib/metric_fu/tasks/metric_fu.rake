require "rake"
require "metric_fu/run"
namespace :metrics do
  def options_tip(task_name)
    "with options, for example:  rake metrics:#{task_name}['cane: {abc_max: 81}']"
  end
  desc "Generate all metrics reports, or #{options_tip('all')}"
  task :all, [:options] do |_t, args|
    MetricFu.run(process_options(args.options))
  end

  desc "Run only specified ;-separated metrics, for example, metrics:only[cane;flog] or #{options_tip('only')}"
  task :only, [:metrics, :options] do |_t, args|
    requested_metrics = args.metrics.to_s.split(";").map(&:strip)
    enabled_metrics = MetricFu::Metric.enabled_metrics.map(&:name)
    metrics_to_run = enabled_metrics.select { |metric| requested_metrics.include?(metric.to_s) }
    MetricFu.run_only(metrics_to_run, process_options(args.options))
  end

  MetricFu::Metric.enabled_metrics.each do |metric|
    name = metric.name
    desc "Generate report for #{name}, or #{options_tip('cane')}"
    task name, [:options] do |_t, args|
      MetricFu.run_only(name, process_options(args.options))
    end
  end

  private

  # from https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/hash/keys.rb
  class Hash
    # Destructively, recursively convert all keys to symbols, as long as they respond
    # to +to_sym+.
    def recursively_symbolize_keys!
      keys.each do |key|
        value = delete(key)
        new_key = key.intern # rescue
        self[new_key] = (value.is_a?(Hash) ? value.dup.recursively_symbolize_keys! : value)
      end
      self
    end
  end

  def process_options(options)
    return {} if options.nil? or options.empty?
    options = YAML.load(options)
    if options.is_a?(Hash)
      p "Got options #{options.recursively_symbolize_keys!.inspect}"
      options
    else
      raise "Invalid options #{options.inspect}, is a #{options.class}, should be a Hash"
    end
  end
end

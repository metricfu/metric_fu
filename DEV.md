## Contracted Interfaces

```ruby
MetricFu.run_dir #=> Dir.pwd
MetricFu.run_dir = 'some_path'
MetricFu.run_path #=> Pathname(Dir.pwd)
MetricFu.root_dir
MetricFu.loader.load_user_configuration
MetricFu.loader.loaded_files
MetricFu.lib_require { 'utility' }
MetricFu.lib_dir #=> metric_fu/lib
MetricFu.lib_require('metrics')  { 'flog/init' }
MetricFu.metrics_require {'flog/init' }
MetricFu.metrics_dir #=> metric_fu/lib/metrics
MetricFu.formatter_require { 'html' }
MetricFu.formatter_dir #=> metric_fu/lib/formatter
MetricFu.reporting_require { 'result' }
MetricFu.reporting_dir #=> metric_fu/lib/reporting
MetricFu.logging_require { 'mf_debugger' }
MetricFu.logging_dir   #=> metric_fu/lib/logging
MetricFu.errors_require { 'analysis_error' }
MetricFu.errors_dir    #=> metric_fu/lib/errors
MetricFu.data_structures_require { 'line_numbers' }
MetricFu.data_structures_dir #=> metric_fu/lib/data_structures
MetricFu.tasks_require { } # Doesn't work as expected. Don't use
MetricFu.tasks_dir           #=> metric_fu/lib/tasks

MetricFu.configuration #=> MetricFu::Configuration.new
MetricFu.configuration.configure_metrics # for each metric, yield to block or runs enable, activate
MetricFu.configuration.configure_metric(:flog) do |metric|
  metric.run_options #=> metric.default_run_options.merge(metric.configured_run_options)
  metric.enable
  metric.enabled = true
  metric.activate
  metric.activated = true
  metric.name #=> :flog
end
```

## Templates

Render _report_footer.html.erb partial:
```ruby
render_partial('report_footer')
```

Render _graph.html.erb partial and set a graph_name instance variable:
```ruby
render_partial 'graph', {:graph_name => 'reek'}
```

## Testing

`bundle exec rspec`

## Forking

## Issues / Pull Requests

* see [CONTRIBUTING](CONTRIBUTING.md)

## Building

`rake build` or `rake install`

## Releasing

0. Run `rake usage_test` to make sure the examples are still valid
1. Update lib/metric_fu/version.rb
2. Update HISTORY.md
3. `rake release`

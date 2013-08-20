def metric_not_activated?(metric_name)
  MetricFu.configuration.configure_metrics
  if MetricFu::Metric.get_metric(metric_name.intern).activated
    false
  else
    p "Skipping #{metric_name} tests, not activated"
    true
  end
end


def read_resource(path_in_resources)
  File.read("#{resources_path}/#{path_in_resources}")
end
def metric_data(path_in_resources)
  metric_path = read_resource("yml/#{path_in_resources}")
  YAML.load( metric_path )
end

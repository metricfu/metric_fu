def metric_not_activated?(metric_name)
  MetricFu.configuration.configure_metrics
  if MetricFu::Metric.get_metric(metric_name.intern).activated
    false
  else
    p "Skipping #{metric_name} tests, not activated"
    true
  end
end

require 'spec_helper'

describe MetricFu::Metric do
  it 'can have its run_options over-written' do
    metric = MetricFu::Metric.get_metric(:flog)
    original_options = metric.run_options.dup
    new_options = {:foo => 'bar'}
    metric.run_options = new_options
    expect(original_options).to_not eq(new_options)
    expect(metric.run_options).to eq(new_options)
  end
  it 'can have its run_options modified' do
    metric = MetricFu::Metric.get_metric(:flog)
    original_options = metric.run_options.dup
    new_options = {:foo => 'bar'}
    metric.run_options.merge!(new_options)
    expect(metric.run_options).to eq(original_options.merge(new_options))
  end
end

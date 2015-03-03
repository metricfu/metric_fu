require "spec_helper"
require "shared/configured"

describe MetricFu::Configuration, "for churn" do
  it_behaves_like "configured" do
    it "should set @churn to {}" do
      load_metric "churn"
      expect(MetricFu::Metric.get_metric(:churn).run_options).to eq(
               start_date: '"1 year ago"', minimum_churn_count: 10, ignore_files: [], data_directory: MetricFu::Io::FileSystem.scratch_directory("churn")
      )
    end
  end
end

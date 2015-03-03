require "spec_helper"
require "shared/configured"

describe MetricFu::Configuration, "for reek" do
  it_behaves_like "configured" do
    it "should set @reek to {:dirs_to_reek => @code_dirs}" do
      load_metric "reek"
      expect(MetricFu::Metric.get_metric(:reek).run_options).to eq(
              config_file_pattern: nil, dirs_to_reek: ["lib"]
      )
    end
  end
end

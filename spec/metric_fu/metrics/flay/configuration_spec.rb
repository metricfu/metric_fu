require "spec_helper"
require "shared/configured"

describe MetricFu::Configuration, "for flay" do
  it_behaves_like "configured" do
    it "should set @flay to {:dirs_to_flay => @code_dirs}" do
      load_metric "flay"
      expect(MetricFu::Metric.get_metric(:flay).run_options).to eq(
              dirs_to_flay: ["lib"], minimum_score: nil
      )
    end
  end
end

require "spec_helper"
require "shared/configured"

describe MetricFu::Configuration, "for flog" do
  it_behaves_like "configured" do
    if MetricFu.configuration.mri?
      it "should set @flog to {:dirs_to_flog => @code_dirs}" do
        load_metric "flog"
        expect(MetricFu::Metric.get_metric(:flog).run_options).to eq(
          all: true,
          continue: true,
          dirs_to_flog: ["lib"],
          quiet: true
         )
      end
    end
  end
end

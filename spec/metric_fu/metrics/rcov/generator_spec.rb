require "spec_helper"
MetricFu.metrics_require { "rcov/generator" }
require "shared/test_coverage"

describe MetricFu::RcovGenerator, "configured as rcov" do
  it_behaves_like "rcov test coverage generator", :rcov do
    describe "emit" do
      before :each do
        options = { external: nil }
        @test_coverage = MetricFu::RcovGenerator.new(@default_options.merge(options))
      end

      it "should set the RAILS_ENV" do
        expect(MetricFu::Utility).to receive(:rm_rf).with(MetricFu::RcovGenerator.metric_directory, verbose: false)
        expect(MetricFu::Utility).to receive(:mkdir_p).with(MetricFu::RcovGenerator.metric_directory)
        options = { environment: "metrics", external: nil }
        @test_coverage = MetricFu::RcovGenerator.new(@default_options.merge(options))
        expect(@test_coverage.command).to include("RAILS_ENV=metrics")
      end
    end
  end
end

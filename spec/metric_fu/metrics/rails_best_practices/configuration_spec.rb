require "spec_helper"
require "shared/configured"

describe MetricFu::Configuration, "for rails_best_practices" do
  it_behaves_like "configured" do
    describe "if #rails? is true " do
      before(:each) do
        @config = MetricFu.configuration
        allow(@config).to receive(:rails?).and_return(true)
        @config.reset
        MetricFu.configure
        %w(rails_best_practices).each do |metric|
          load_metric metric
        end
      end

      describe "#set_graphs " do
        it "should set the graphs to include rails_best_practices" do
          expect(MetricFu::Metric.get_metric(:rails_best_practices).has_graph?).to be_truthy
        end
      end

      it "should set @rails_best_practices to {}" do
        load_metric "rails_best_practices"
        expect(MetricFu::Metric.get_metric(:rails_best_practices).run_options).to eql({})
      end
    end

    describe "if #rails? is false " do
      before(:each) do
        get_new_config
        allow(@config).to receive(:rails?).and_return(false)
        %w(rails_best_practices).each do |metric|
          load_metric metric
        end
      end

      it "should set the registered code_dirs to ['lib']" do
        expect(directory("code_dirs")).to eq(["lib"])
      end
    end
  end
end

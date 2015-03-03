require "spec_helper"
require "shared/configured"

describe MetricFu::Configuration, "for roodi" do
  it_behaves_like "configured" do
    it "should set @roodi to {:dirs_to_roodi => @code_dirs}" do
      load_metric "roodi"
      expect(MetricFu::Metric.get_metric(:roodi).run_options).to eq(
               dirs_to_roodi: directory("code_dirs"),
               roodi_config: "#{directory('root_directory')}/config/roodi_config.yml"
              )
    end
  end
end

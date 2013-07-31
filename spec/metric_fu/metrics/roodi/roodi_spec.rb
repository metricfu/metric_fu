require "spec_helper"

describe Roodi do
  describe "emit" do
    it "should add config options when present" do
      options = {:roodi_config => 'lib/config/roodi_config.yml', :dirs_to_roodi => []}
      roodi = MetricFu::Roodi.new(options)
      roodi.should_receive(:`).with(/-config=lib\/config\/roodi_config\.yml/).and_return("")
      roodi.emit
    end

    it "should NOT add config options when NOT present" do
      options = {:dirs_to_roodi => []}
      roodi = MetricFu::Roodi.new(options)
      roodi.stub(:`)
      roodi.should_receive(:`).with(/-config/).never
      roodi.emit
    end
  end
end

require 'spec_helper'

describe RubocopGenerator do 
  describe "emit method" do 
    it "should add config options when present" do 
      options = {
        config: ".rubocop.yml",
        dirs_to_rubocop: ["lib"]
      }
      rubocop = MetricFu::RubocopGenerator.new(options)
      rubocop.should_receive(:`).with("rubocop --format json --config .rubocop.yml lib")
      output = rubocop.emit
    end

    it "should NOT add config options when NOT present" do 
      options = {dirs_to_rubocop: ["lib"]}
      rubocop = MetricFu::RubocopGenerator.new(options)
      rubocop.should_receive(:`).with(/--config/).never
      rubocop.emit
    end
  end
end
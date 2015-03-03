require "spec_helper"
MetricFu.reporting_require { "result" }

describe MetricFu do
  describe "#result" do
    it "should return an instance of Result" do
      expect(MetricFu.result.instance_of?(Result)).to be(true)
    end
  end
end

describe MetricFu::Result do
  before(:each) do
    @result = MetricFu::Result.new
  end

  describe "#as_yaml" do
    it "should call #result_hash" do
      result_hash = double("result_hash")
      expect(result_hash).to receive(:to_yaml)

      expect(@result).to receive(:result_hash).and_return(result_hash)
      @result.as_yaml
    end
  end

  describe "#result_hash" do
  end

  describe "#add" do
    it "should add a passed hash to the result_hash instance variable" do
      result_type = double("result_type")
      allow(result_type).to receive(:to_s).and_return("type")

      result_inst = double("result_inst")
      expect(result_type).to receive(:new).and_return(result_inst)

      expect(result_inst).to receive(:generate_result).and_return(a: "b")
      expect(result_inst).to receive(:respond_to?).and_return(false)

      expect(MetricFu::Generator).to receive(:get_generator).
        with(result_type).and_return(result_type)
      result_hash = double("result_hash")
      expect(result_hash).to receive(:merge!).with(a: "b")
      expect(@result).to receive(:result_hash).and_return(result_hash)
      expect(@result).to receive(:metric_options_for_result_type).with(result_type)
      @result.add(result_type)
    end
  end
end

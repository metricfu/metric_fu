require "spec_helper"

describe MetricFu do

  describe "#result" do
    it 'should return an instance of Result' do
      MetricFu.result.instance_of?(Result).should be(true)
    end
  end
end

describe MetricFu::Result do

  before(:each) do
    @result = MetricFu::Result.new
  end

  describe "#as_yaml" do
    it 'should call #result_hash' do
      result_hash = double('result_hash')
      result_hash.should_receive(:to_yaml)

      @result.should_receive(:result_hash).and_return(result_hash)
      @result.as_yaml
    end
  end

  describe "#result_hash" do
  end

  describe "#add" do
    it 'should add a passed hash to the result_hash instance variable' do
      result_type = double('result_type')
      result_type.stub(:to_s).and_return('type')

      result_inst = double('result_inst')
      result_type.should_receive(:new).and_return(result_inst)

      result_inst.should_receive(:generate_result).and_return({:a => 'b'})
      result_inst.should_receive(:respond_to?).and_return(false)

      MetricFu::Generator.should_receive(:get_generator).
               with(result_type).and_return(result_type)
      result_hash = double('result_hash')
      result_hash.should_receive(:merge!).with({:a => 'b'})
      @result.should_receive(:result_hash).and_return(result_hash)
      @result.should_receive(:metric_options_for_result_type).with(result_type)
      @result.add(result_type)
    end
  end
end

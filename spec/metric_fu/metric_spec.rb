require "spec_helper"

describe MetricFu::Metric do
  before do
    @metric = MetricFu::Metric.get_metric(:flog)
    # @original_options = @metric.run_options.dup
  end

  # it "can have its run_options over-written" do
  # new_options = {:foo => 'bar'}
  # @metric.run_options = new_options
  # expect(@original_options).to_not eq(new_options)
  # expect(@metric.run_options).to eq(new_options)
  # end

  # it "can have its run_options modified" do
  # new_options = {:foo => 'bar'}
  # @metric.run_options.merge!(new_options)
  # expect(@metric.run_options).to eq(@original_options.merge(new_options))
  # end

  context "given a valid configurable option" do
    before do
      allow(@metric).to receive(:default_run_options).and_return(foo: "baz")
    end

    it "can be configured as an attribute" do
      @metric.foo = "qux"
      expect(@metric.run_options[:foo]).to eq("qux")
    end
  end

  context "given an invalid configurable option" do
    before do
      allow(@metric).to receive(:default_run_options).and_return({})
    end

    it "raises an error" do
      expect { @metric.foo = "bar" }.to raise_error(RuntimeError, /not a valid configuration option/)
    end
  end

  after do
    @metric.configured_run_options.clear
  end
end

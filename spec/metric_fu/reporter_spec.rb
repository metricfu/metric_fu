require "spec_helper"
MetricFu.lib_require { "reporter" }

describe MetricFu::Reporter do
  context "given a single formatter" do
    before do
      @formatter = double("formatter")
      allow(@formatter).to receive(:to_a).and_return([@formatter])
      @reporter = Reporter.new(@formatter)
    end

    it "notifies the formatter" do
      expect(@formatter).to receive(:start)
      expect(@formatter).to receive(:finish)
      @reporter.start
      @reporter.finish
    end

    it "only sends notifications when supported by formatter" do
      allow(@formatter).to receive(:respond_to?).with(:display_results).and_return(false)
      expect(@formatter).not_to receive(:display_results)
      @reporter.display_results
    end
  end

  context "given multiple formatters" do
    before do
      @formatters = [double("formatter"), double("formatter")]
      @reporter = Reporter.new(@formatters)
    end

    it "notifies all formatters" do
      @formatters.each do |formatter|
        expect(formatter).to receive(:start)
        expect(formatter).to receive(:finish)
      end
      @reporter.start
      @reporter.finish
    end
  end
end

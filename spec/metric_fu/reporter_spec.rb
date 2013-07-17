require "spec_helper"

describe MetricFu::Reporter do

  context 'given a single formatter' do
    before do
      @formatter = double('formatter')
      @formatter.stub(:to_a).and_return([@formatter])
      @reporter = Reporter.new(@formatter)
    end

    it 'notifies the formatter' do
      @formatter.should_receive(:start)
      @formatter.should_receive(:finish)
      @reporter.start
      @reporter.finish
    end

    it 'only sends notifications when supported by formatter' do
      @formatter.stub(:respond_to?).with(:display_results).and_return(false)
      @formatter.should_not_receive(:display_results)
      @reporter.display_results
    end
  end

  context 'given multiple formatters' do
    before do
      @formatters = [double('formatter'), double('formatter')]
      @reporter = Reporter.new(@formatters)
    end

    it 'notifies all formatters' do
      @formatters.each do |formatter|
        formatter.should_receive(:start)
        formatter.should_receive(:finish)
      end
      @reporter.start
      @reporter.finish
    end
  end
end

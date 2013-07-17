require "spec_helper"
require 'fakefs/safe'

describe MetricFu::Formatter::HTML do

  before do
    setup_fs

    # TODO: Use mock metrics?
    # Right now, have to select from metrics
    # based on platform, resulting in slow specs
    # for some platforms.
    @metric_with_graph = MetricFu.configuration.mri? ? :cane : :flay
    @metric_without_graph = :hotspots
    MetricFu.result.add(@metric_with_graph) # metric w/ graph
    MetricFu.result.add(@metric_without_graph) # metric w/out graph
  end

  context "In general" do

    it "creates a report yaml file" do
      # For backward compatibility.
      expect {
      MetricFu::Formatter::HTML.new.finish
      }.to create_file("#{MetricFu.base_directory}/report.yml")
    end

    it "creates a data yaml file" do
      # For use with graphs.
      expect {
      MetricFu::Formatter::HTML.new.finish
      }.to create_file("#{MetricFu.data_directory}/#{Time.now.strftime("%Y%m%d")}.yml")
    end

    it "creates a report index html file" do
      expect {
      MetricFu::Formatter::HTML.new.finish
      }.to create_file("#{MetricFu.output_directory}/index.html")
    end

    it "creates templatized html files for each metric" do
      expect {
      MetricFu::Formatter::HTML.new.finish
      }.to create_files([
        "#{MetricFu.output_directory}/#{@metric_with_graph}.html",
        "#{MetricFu.output_directory}/#{@metric_without_graph}.html"
      ])
    end

    it "copies common javascripts to the output directory" do
      expect {
      MetricFu::Formatter::HTML.new.finish
      }.to create_file("#{MetricFu.output_directory}/bluff*.js")
    end

    it "creates graphs for appropriate metrics" do
      expect {
      MetricFu::Formatter::HTML.new.finish
      }.to create_files([
        "#{MetricFu.output_directory}/#{@metric_with_graph}.js",
      ])
    end

    context 'when on OS X' do
      before do
        MetricFu.configuration.stub(:platform).and_return('darwin')
      end

      it "can open the results in the browser" do
        formatter = MetricFu::Formatter::HTML.new
        formatter.should_receive(:system).with("open #{Pathname.pwd.join(MetricFu.output_directory).join('index.html')}")
        formatter.finish
        formatter.display_results
      end
    end

  end

  context "given a custom output directory" do

    before do
      @output = 'customdir'
    end

    it "creates the report index html file in the custom output directory" do
      expect {
      MetricFu::Formatter::HTML.new(output: @output).finish
      }.to create_file("#{MetricFu.base_directory}/#{@output}/index.html")
    end

    it "creates templatized html files for each metric in the custom output directory" do
      expect {
      MetricFu::Formatter::HTML.new(output: @output).finish
      }.to create_files([
        "#{MetricFu.base_directory}/#{@output}/#{@metric_with_graph}.html",
        "#{MetricFu.base_directory}/#{@output}/#{@metric_without_graph}.html"
      ])
    end

    it "copies common javascripts to the custom output directory" do
      expect {
      MetricFu::Formatter::HTML.new(output: @output).finish
      }.to create_file("#{MetricFu.base_directory}/#{@output}/bluff*.js")
    end

    it "creates graphs for appropriate metrics in the custom output directory " do
      expect {
      MetricFu::Formatter::HTML.new(output: @output).finish
      }.to create_file(
        "#{MetricFu.base_directory}/#{@output}/#{@metric_with_graph}.js",
      )
    end

    context 'when on OS X' do
      before do
        MetricFu.configuration.stub(:platform).and_return('darwin')
      end

      it "can open the results in the browser from the custom output directory" do
        formatter = MetricFu::Formatter::HTML.new(output: @output)
        path = Pathname.pwd.join("#{MetricFu.base_directory}/#{@output}/index.html")
        formatter.should_receive(:system).with("open #{path}")
        formatter.finish
        formatter.display_results
      end
    end

  end

  after do
    cleanup_fs
  end

end

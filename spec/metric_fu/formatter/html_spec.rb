require "spec_helper"
MetricFu.formatter_require { "html" }

describe MetricFu::Formatter::HTML do
  before do
    setup_fs

    # TODO: Use mock metrics?
    # Right now, have to select from metrics
    # based on platform, resulting in slow specs
    # for some platforms.
    config = MetricFu.configuration
    if config.mri?
      @metric_with_graph = :cane
    else
      @metric_with_graph = :stats
      config.templates_configuration do |c|
        c.syntax_highlighting = false
      end
    end
    allow(MetricFu::Metric.get_metric(@metric_with_graph)).to receive(:run_external).and_return("")
    @metric_without_graph = :hotspots
    config.configure_metrics.each do |metric|
      metric.enabled = true if [@metric_with_graph, @metric_without_graph].include?(metric.name)
    end

    MetricFu.result.add(@metric_with_graph) # metric w/ graph
    MetricFu.result.add(@metric_without_graph) # metric w/out graph
  end

  def directory(name)
    MetricFu::Io::FileSystem.directory(name)
  end

  context "In general" do
    it "creates a report yaml file" do
      # For backward compatibility.
      expect {
        MetricFu::Formatter::HTML.new.finish
      }.to create_file("#{directory('base_directory')}/report.yml")
    end

    it "creates a data yaml file" do
      # For use with graphs.
      expect {
        MetricFu::Formatter::HTML.new.finish
      }.to create_file("#{directory('data_directory')}/#{MetricFu.report_id}.yml")
    end

    it "creates a report index html file" do
      expect {
        MetricFu::Formatter::HTML.new.finish
      }.to create_file("#{directory('output_directory')}/index.html")
    end

    it "creates templatized html files for each metric" do
      expect {
        MetricFu::Formatter::HTML.new.finish
      }.to create_files([
        "#{directory('output_directory')}/#{@metric_with_graph}.html",
        "#{directory('output_directory')}/#{@metric_without_graph}.html"
      ])
    end

    it "copies common javascripts to the output directory" do
      expect {
        MetricFu::Formatter::HTML.new.finish
      }.to create_file("#{directory('output_directory')}/highcharts*.js")
    end

    it "creates graphs for appropriate metrics" do
      expect {
        MetricFu::Formatter::HTML.new.finish
      }.to create_files([
        "#{directory('output_directory')}/#{@metric_with_graph}.js",
      ])
    end

    it "can open the results in the browser" do
      allow(MetricFu.configuration).to receive(:is_cruise_control_rb?).and_return(false)
      formatter = MetricFu::Formatter::HTML.new
      path = MetricFu.run_path.join(directory("output_directory"))
      uri = URI.join(URI.escape("file://#{path}/"), "index.html")
      expect(Launchy).to receive(:open).with(uri)
      formatter.finish
      formatter.display_results
    end
  end

  context "given a custom output directory" do
    before do
      @output = "customdir"
    end

    it "creates the report index html file in the custom output directory" do
      expect {
        MetricFu::Formatter::HTML.new(output: @output).finish
      }.to create_file("#{directory('base_directory')}/#{@output}/index.html")
    end

    it "creates templatized html files for each metric in the custom output directory" do
      expect {
        MetricFu::Formatter::HTML.new(output: @output).finish
      }.to create_files([
        "#{directory('base_directory')}/#{@output}/#{@metric_with_graph}.html",
        "#{directory('base_directory')}/#{@output}/#{@metric_without_graph}.html"
      ])
    end

    it "copies common javascripts to the custom output directory" do
      expect {
        MetricFu::Formatter::HTML.new(output: @output).finish
      }.to create_file("#{directory('base_directory')}/#{@output}/highcharts*.js")
    end

    it "creates graphs for appropriate metrics in the custom output directory " do
      expect {
        MetricFu::Formatter::HTML.new(output: @output).finish
      }.to create_file(
        "#{directory('base_directory')}/#{@output}/#{@metric_with_graph}.js",
      )
    end

    it "can open the results in the browser from the custom output directory" do
      allow(MetricFu.configuration).to receive(:is_cruise_control_rb?).and_return(false)
      formatter = MetricFu::Formatter::HTML.new(output: @output)
      path = MetricFu.run_path.join("#{directory('base_directory')}/#{@output}")
      uri = URI.join(URI.escape("file://#{path}/"), "index.html")
      expect(Launchy).to receive(:open).with(uri)
      formatter.finish
      formatter.display_results
    end
  end

  after do
    cleanup_fs
  end
end

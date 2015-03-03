require "spec_helper"

describe "Bluff graphers responding to #graph!" do
  before do
    setup_fs
  end
  after do
    cleanup_fs
  end
  it "should write chart file" do
    graphs = {}
    available_graphs = MetricFu::Metric.enabled_metrics.select(&:has_graph?).map(&:name)
    available_graphs.each do |graph|
      grapher_name = graph.to_s.gsub("MetricFu::", "").gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      grapher_name =  grapher_name + "Grapher"
      graphs[graph] = MetricFu.const_get(grapher_name).new
    end
    graphs.each do |key, val|
      val.graph!
      output_dir = File.expand_path(File.join(MetricFu::Io::FileSystem.directory("output_directory")))
      expect { File.read(File.join(output_dir, "#{key.to_s.downcase}.js")) }.not_to raise_error
    end
  end
end

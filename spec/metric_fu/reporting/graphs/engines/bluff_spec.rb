require "spec_helper"

describe "Bluff graphers responding to #graph!" do
  it "should write chart file" do
    graphs = {}
    available_graphs = MetricFu::Metric.enabled_metrics.select{|m|m.has_graph?}.map(&:metric_name)
    available_graphs.each do |graph|
      grapher_name = graph.to_s.gsub("MetricFu::",'').gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      grapher_name =  grapher_name+"BluffGrapher"
      graphs[graph] = MetricFu.const_get(grapher_name).new
    end
    graphs.each do |key, val|
      val.graph!
      output_dir = File.expand_path(File.join(MetricFu::Io::FileSystem.directory('output_directory')))
      lambda{ File.open(File.join(output_dir, "#{key.to_s.downcase}.js")) }.should_not raise_error
    end
  end
end

require "multi_json"
module MetricFu
  class Grapher
    @graphers = []
    # @return all subclassed graphers [Array<MetricFu::Grapher>]
    def self.graphers
      @graphers
    end

    def self.inherited(subclass)
      @graphers << subclass
    end

    def self.get_grapher(metric)
      graphers.find { |grapher|grapher.metric.to_s == metric.to_s }
    end

    attr_accessor :output_directory

    def initialize(opts = {})
      self.output_directory = opts[:output_directory]
    end

    def output_directory
      @output_directory || MetricFu::Io::FileSystem.directory("output_directory")
    end

    def get_metrics(_metrics, _sortable_prefix)
      not_implemented
    end

    def graph!
      labels = MultiJson.dump(@labels)
      content = <<-EOS
        var graph_title = '#{title}';
        #{build_data(data)}
        var graph_labels = #{labels};
      EOS
      File.open(File.join(output_directory, output_filename), "w") { |f| f << content }
    end

    def title
      not_implemented
    end

    def date
      not_implemented
    end

    def output_filename
      not_implemented
    end

    private

    def build_data(data)
      "var graph_series = [" << Array(data).map do |label, datum|
        "{name: '#{label}', data: [#{datum}]}"
      end.join(",") << "];"
    end

    def not_implemented
      raise "#{__LINE__} in #{__FILE__} from #{caller[0]}"
    end
  end
end

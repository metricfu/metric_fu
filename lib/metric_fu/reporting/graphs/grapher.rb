# Class opened and modified by requiring a graph engine
require 'multi_json'
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
      graphers.find{|grapher|grapher.metric.to_s == metric.to_s}
    end

    def self.gem_name
      'bluff'
    end

    BLUFF_GRAPH_SIZE = "1000x600"
    BLUFF_DEFAULT_OPTIONS = <<-EOS
      var g = new Bluff.Line('graph', "#{BLUFF_GRAPH_SIZE}");
      g.theme_37signals();
      g.tooltips = true;
      g.title_font_size = "24px"
      g.legend_font_size = "12px"
      g.marker_font_size = "10px"
    EOS

    attr_accessor :output_directory

    def initialize(opts = {})
      self.class.require_graphing_gem
      self.output_directory = opts[:output_directory]
    end

    def output_directory
      @output_directory || MetricFu::Io::FileSystem.directory('output_directory')
    end

    def self.require_graphing_gem
      require self.gem_name
    rescue LoadError => e
      mf_log "Failed requiring graphing gem #{e.message} #{e.backtrace.join("\t\n")}"
    end

    def get_metrics(metrics, sortable_prefix)
      not_implemented
    end

    def graph!
      title = send(:title)
      data = send(:data)
      labels = MultiJson.dump(@labels)
      output_filename = send(:output_filename)
      content = <<-EOS
        #{BLUFF_DEFAULT_OPTIONS}
        g.title = '#{title}';
        #{build_data(data)}
        g.labels = #{labels};
        g.draw();
      EOS
      File.open(File.join(self.output_directory, output_filename), 'w') {|f| f << content }
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
      Array(data).map do |label, datum|
        "g.data('#{label}', [#{datum}]);"
      end.join("\n")
    end

    def not_implemented
      raise "#{__LINE__} in #{__FILE__} from #{caller[0]}"
    end

  end
end

module MetricFu
  def self.graph
    @graph ||= Graph.new
  end

  class Graph
    attr_accessor :graphers

    def initialize
      self.graphers = []
    end

    def add(metric_name, _graph_engine, output_directory = MetricFu::Io::FileSystem.directory("output_directory"))
      grapher = MetricFu::Grapher.get_grapher(metric_name).
                new.tap { |g| g.output_directory = output_directory }
      graphers.push grapher
    rescue NameError => e
      mf_log "#{e.message} called in MetricFu::Graph.add with #{graph_type}"
    end

    def generate
      return if graphers.empty?
      mf_log "Generating graphs"
      generate_graphs_for_files
      graph!
    rescue NameError => e
      mf_log "#{e.message} called in MetricFu::Graph generate"
    end

    private

    def metric_files
      MetricFu::Utility.glob(
        File.join(MetricFu::Io::FileSystem.directory("data_directory"), "*.yml")
      ).sort
    end

    def generate_graphs_for_files
      metric_files.each do |metric_file|
        generate_graphs_for_file(metric_file)
      end
    end

    def generate_graphs_for_file(metric_file)
      mf_log "Generating graphs for #{metric_file}"
      date_parts = year_month_day_from_filename(metric_file)
      metrics = MetricFu::Utility.load_yaml(metric_file)

      build_graph(metrics, "#{date_parts[:m]}/#{date_parts[:d]}")
    rescue NameError => e
      mf_log "#{e.message} called in MetricFu::Graph.generate with #{metric_file}"
    end

    def build_graph(metrics, sortable_prefix)
      graphers.each do |grapher|
        grapher.get_metrics(metrics, sortable_prefix)
      end
    end

    def graph!
      graphers.each(&:graph!)
    end

    def year_month_day_from_filename(path_to_file_with_date)
      date = path_to_file_with_date.match(/\/(\d+).yml$/)[1]
      { y: date[0..3].to_i, m: date[4..5].to_i, d: date[6..7].to_i }
    end
  end
end

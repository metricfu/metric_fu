module MetricFu
  class GraphEngine

    attr_accessor :graph_engines, :graph_engine
    def initialize
      @graph_engines = [:bluff, :gchart]
      @graph_engine = :bluff
    end

    def add_graph_engine(graph_engine)
      self.graph_engines = (graph_engines << graph_engine).uniq
    end

    def configure_graph_engine(graph_engine)
      self.graph_engine = graph_engine
    end

  end
end

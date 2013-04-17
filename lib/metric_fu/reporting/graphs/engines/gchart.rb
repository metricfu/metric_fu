module MetricFu
  module GchartGrapher
    COLORS = %w{009999 FF7400 A60000 008500 E6399B 344AD7 00B860 D5CCB9}
    GCHART_GRAPH_SIZE = "945x317" # maximum permitted image size is 300000 pixels

    NUMBER_OF_TICKS = 6
    def determine_y_axis_scale(values)
      values.collect! {|val| val || 0.0 }
      if values.empty?
        @max_value = 10
        @yaxis = [0, 2, 4, 6, 8, 10]
      else
        @max_value = values.max + Integer(0.1 * values.max)
        portion_size = (@max_value / (NUMBER_OF_TICKS - 1).to_f).ceil
        @yaxis = []
        NUMBER_OF_TICKS.times {|n| @yaxis << Integer(portion_size * n) }
        @max_value = @yaxis.last
      end
    end
  end

  class Grapher
    include MetricFu::GchartGrapher

    def self.require_graphing_gem
      require 'gchart' if MetricFu.graph_engine == :gchart
    rescue LoadError
      puts "#"*99 + "\n" +
           "If you want to use google charts for graphing, you'll need to install the googlecharts rubygem." +
           "\n" + "#"*99
    end
  end

end

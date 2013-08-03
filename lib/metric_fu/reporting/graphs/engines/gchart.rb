module MetricFu
  module GchartGrapher
    COLORS = %w{009999 FF7400 A60000 008500 E6399B 344AD7 00B860 D5CCB9}
    GCHART_GRAPH_SIZE = "945x317" # maximum permitted image size is 300000 pixels
    NUMBER_OF_TICKS = 6

    # @see gchart_line_options
    def graph!
      options = gchart_line_options.reject{|_,v|v.nil?}
      Gchart.line(options)
    end
    # @note Some values are initialized as nil to maintain consistent
    # key ordering for the tests.  Any keys with nil values are removed
    # before graphing
    def gchart_line_options
      {
        :size => GCHART_GRAPH_SIZE,
        :title => URI.encode(title),
        :data => data,
        :stacked => nil,
        :bar_colors => nil,
        :legend => nil,
        :custom => nil,
        :max_value => nil,
        :axis_with_labels => nil,
        :axis_labels => nil,
        :format => 'file',
        :filename => File.join(self.output_directory, output_filename),
      }.merge(y_axis_scale_options)
    end
    def y_axis_scale_options
      determine_y_axis_scale(y_axis_scale_argument)
      {
        :max_value => @max_value,
        :axis_with_labels => 'x,y',
        :axis_labels => [@labels.values, @yaxis],
      }
    end
    def determine_y_axis_scale(values)
      values = Array(values)
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
    def y_axis_scale_argument
      raise "#{__LINE__} in #{__FILE__} from #{caller.join('\n')}"
    end
  end

  class Grapher

    def self.require_graphing_gem
      if MetricFu.configuration.graph_engine == :gchart
        require 'gchart'
        include MetricFu::GchartGrapher
      end
    rescue LoadError
      mf_log "#"*99 + "\n" +
           "If you want to use google charts for graphing, you'll need to install the googlecharts rubygem." +
           "\n" + "#"*99
    end
  end

end

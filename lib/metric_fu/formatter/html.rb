module MetricFu
  module Formatter
    class HTML
      include MetricFu::Io

      def initialize(opts={})
        @options = opts
      end

      def finish
        mf_log "** SAVING REPORTS"
        mf_debug "** SAVING REPORT YAML OUTPUT TO #{MetricFu.base_directory}"
        MetricFu::Formatter::YAML.new.finish

        mf_debug "** SAVING REPORT DATA OUTPUT TO #{MetricFu.data_directory}"
        MetricFu::Formatter::YAML.new(
          output: Pathname.pwd.join("#{MetricFu.data_directory}/#{Time.now.strftime("%Y%m%d")}.yml")
        ).finish

        mf_debug "** SAVING TEMPLATIZED REPORT"
        save_templatized_result
        save_graphs
      end

      def write_template(output, file)
        write_output(output, "#{self.output_directory}/#{file}")
      end

      def display_results
        if self.open_in_browser?
          mf_debug "** OPENING IN BROWSER FROM #{self.output_directory}"
          self.show_in_browser(self.output_directory)
        end
      end

      protected

      def output_directory
        @output ||= dir_for(@options[:output]) || Pathname.pwd.join(MetricFu.output_directory)
      end

      # Instantiates a new template class based on the configuration set
      # in MetricFu::Configuration, or through the MetricFu.config block
      # in your rake file (defaults to the included AwesomeTemplate),
      # assigns the result_hash to the result_hash in the template, and
      # tells the template to to write itself out.
      def save_templatized_result
        @template = MetricFu.template_class.new
        @template.output_directory = self.output_directory
        @template.result = MetricFu.result.result_hash
        @template.per_file_data = MetricFu.result.per_file_data
        @template.formatter = self
        @template.write
      end

      def save_graphs
        mf_log "** GENERATING GRAPHS"
        mf_debug "** PREPARING TO GRAPH"
        MetricFu.graphs.each {|graph|
          mf_debug "** Graphing #{graph} with #{MetricFu.graph_engine}"
          MetricFu.graph.add(graph, MetricFu.graph_engine, self.output_directory)
        }
        mf_debug "** GENERATING GRAPH"
        MetricFu.graph.generate
      end

      # Checks to discover whether we should try and open the results
      # of the report in the browser on this system.  We only try and open
      # in the browser if we're on OS X and we're not running in a
      # CruiseControl.rb environment.  See MetricFu.configuration for more
      # details about how we make those guesses.
      #
      # @return Boolean
      #   Should we open in the browser or not?
      def open_in_browser?
        MetricFu.configuration.platform.include?('darwin') &&
          ! MetricFu.configuration.is_cruise_control_rb?
      end

      # Shows 'index.html' from the passed directory in the browser
      # if we're able to open the browser on this platform.
      #
      # @param dir String
      #   The directory path where the 'index.html' we want to open is
      #   stored
      def show_in_browser(dir)
        system("open #{dir}/index.html") if open_in_browser?
      end
    end
  end
end

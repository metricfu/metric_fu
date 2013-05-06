# Foo

    def run_reports
      report_metrics.each {|metric|
        mf_debug "** STARTING METRIC #{metric}"
        MetricFu.report.add(metric)
        mf_debug "** ENDING METRIC #{metric}"
      }
    end

  # = MetricFu::Report
  #
  # The Report class is responsible two things:
  #
  # It adds information to the yaml report, produced by the system
  # as a whole, for each of the generators used in this test run.
  #
  # It also handles passing the information from each generator used
  # in this test run out to the template class set in
  # MetricFu::Configuration.

    # Adds a hash from a passed report, produced by one of the Generator
    # classes to the aggregate report_hash managed by this hash.
    #
    # @param report_type Hash
    #   The hash to add to the aggregate report_hash
    def add(report_type)
      report = report_type_class_instance.generate_report
      report_hash.merge!( report )

      inst.per_file_info(per_file_data) if inst.respond_to?(:per_file_info)
    end

  # = MetricFu::Generator
  #
  # The Generator class is an abstract class that provides the
  # skeleton for producing different types of metrics.
  #
  # It drives the production of the metrics through a template
  # method - #generate_report(options={}).  This method calls
  # #emit, #analyze and #to_h in order to produce the metrics.
  #
  # To implement a concrete class to generate a metric, therefore,
  # the class must implement those three methods.
  #
  # * #emit should take care of running the metric tool and
  #   gathering its output.
  # * #analyze should take care of manipulating the output from
  #   #emit and making it possible to store it in a programmatic way.
  # * #to_h should provide a hash representation of the output from
  #   #analyze ready to be serialized into yaml at some point.
  #
  # == Pre-conditions
  #
  # Based on the class name of the concrete class implementing a
  # Generator, the Generator class will create a 'metric_directory'
  # named after the class under the MetricFu.scratch_directory, where
  # any output from the #emit method should go.
  #
  # It will also create the MetricFu.output_directory if neccessary, and
  # in general setup the directory structure that the MetricFu system
  # expects.

    # Creates a new generator and returns the output of the
    # #generate_report method.  This is the typical way to
    # generate a new MetricFu report. For more information see
    # the #generate_report instance method.
    #
    # @params options Hash
    #   A currently unused hash to configure the Generator
    #
    # @see generate_report
    def self.generate_report(options={})
      generator = self.new(options)
      generator.generate_report
    end
    def remove_excluded_files(paths, globs_to_remove = MetricFu.file_globs_to_ignore)
      files_to_remove = []
      globs_to_remove.each do |glob|
        files_to_remove.concat(Dir[glob])
      end
      paths - files_to_remove
    end

    # Defines some hook methods for the concrete classes to hook into.
    %w[emit analyze].each do |meth|
      define_method("before_#{meth}".to_sym) {}
      define_method("after_#{meth}".to_sym) {}
    end
    define_method("before_to_h".to_sym) {}

    # Provides a template method to drive the production of a metric
    # from a concrete implementation of this class.  Each concrete
    # class must implement the three methods that this template method
    # calls: #emit, #analyze and #to_h.  For more details, see the
    # class documentation.
    #
    # This template method also calls before_emit, after_emit... etc.
    # methods to allow extra hooks into the processing methods, and help
    # to keep the logic of your Generators clean.
    def generate_report
      mf_debug "Executing #{self.class.to_s.gsub(/.*::/, '')}"

      %w[emit analyze].each do |meth|
        send("before_#{meth}".to_sym)
        send("#{meth}".to_sym)
        send("after_#{meth}".to_sym)
      end
      before_to_h()
      to_h()
    end

    ### HOTSPOTS GENERATOR ####

    def emit
      @analyzer = MetricFu::HotspotAnalyzer.new(MetricFu.report.report_hash)
    end

    def analyze
      @hotspots = @analyzer && @analyzer.hotspots || {}
    end

    def to_h
      {:hotspots => @hotspots}
    end

    #########
    def save_reports
      mf_debug "** SAVING REPORT YAML OUTPUT TO #{MetricFu.base_directory}"
      MetricFu.report.save_output(MetricFu.report.as_yaml,
                                  MetricFu.base_directory,
                                  "report.yml")
      mf_debug "** SAVING REPORT DATA OUTPUT TO #{MetricFu.data_directory}"
      MetricFu.report.save_output(MetricFu.report.as_yaml,
                                  MetricFu.data_directory,
                                  "#{Time.now.strftime("%Y%m%d")}.yml")
      mf_debug "** SAVING TEMPLATIZED REPORT"
      MetricFu.report.save_templatized_report
    end
    # NetricFu::Report
    # Saves the passed in content to the passed in directory.  If
    # a filename is passed in it will be used as the name of the
    # file, otherwise it will default to 'index.html'
    #
    # @param content String
    #   A string containing the content (usually html) to be written
    #   to the file.
    #
    # @param dir String
    #   A dir containing the path to the directory to write the file in.
    #
    # @param file String
    #   A filename to save the path as.  Defaults to 'index.html'.
    #
    def save_output(content, dir, file='index.html')
      open("#{dir}/#{file}", "w") do |f|
        f.puts content
      end
    end
    ##############
    def save_graphs
      mf_debug "** PREPARING TO GRAPH"
      MetricFu.graphs.each {|graph|
        mf_debug "** Graphing #{graph} with #{MetricFu.graph_engine}"
        MetricFu.graph.add(graph, MetricFu.graph_engine)
      }
      mf_debug "** GENERATING GRAPH"
      MetricFu.graph.generate
    end
    # MetricFu::Graph
    def add(graph_type, graph_engine)
      grapher_name = graph_type.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase } + graph_engine.to_s.capitalize + "Grapher"
      self.clazz.push MetricFu.const_get(grapher_name).new
    end


    def generate
      return if self.clazz.empty?
      puts "Generating graphs"
      Dir[File.join(MetricFu.data_directory, '*.yml')].sort.each do |metric_file|
        puts "Generating graphs for #{metric_file}"
        date_parts = year_month_day_from_filename(metric_file)
        metrics = YAML::load(File.open(metric_file))

        self.clazz.each do |grapher|
          grapher.get_metrics(metrics, "#{date_parts[:m]}/#{date_parts[:d]}")
        end
      end
      self.clazz.each do |grapher|
        grapher.graph!
      end
    end

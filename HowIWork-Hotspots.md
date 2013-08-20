MetricFu.report.add(:hotspots)
  MetricFu::Hotspots.generate_report
   # per_file_data/info

  # * #emit should take care of running the metric tool and
  #   gathering its output.
  # * #analyze should take care of manipulating the output from
  #   #emit and making it possible to store it in a programmatic way.
  # * #to_h should provide a hash representation of the output from
  #   #analyze ready to be serialized into yaml at some point.
  #
  ### HOTSPOTS GENERATOR ####
  before_emit
  emit
    report_results = MetricFu.report.report_hash # the result of cumulative generate_report
    @analyzer = MetricFu::HotspotAnalyzer.new(report_results)

*****columns ["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"]
*****tables #<MetricFu::AnalyzerTables:0x007fce888a2060 @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"]>

:**** table
#<MetricFu::Table:0x007ff2dbcf0f50 @rows=[], @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"], @make_index=true, @metric_index={}>

*****analyzer #<FlayHotspot:0x007ff2dbda7818>
*****analyzer report {:total_score=>"444", :matches=>[{:reason=>"1) Similar code found in :iter (mass = 224)", :matches=>[{:name=>"lib/metric_fu/metrics/saikuro/template_awesome/saikuro.html.erb", :line=>"41"}, {:name=>"lib/metric_fu/metrics/saikuro/template_standard/saikuro.html.erb", :line=>"51"}]}, {:reason=>"2) Similar code found in :iter (mass = 220)", :matches=>[{:name=>"lib/metric_fu/metrics/flog/template_awesome/flog.html.erb", :line=>"35"}, {:name=>"lib/metric_fu/metrics/flog/template_standard/flog.html.erb", :line=>"35"}]}]}
*****analyzer table #<MetricFu::Table:0x007ff2dbcf0f50 @rows=[#<MetricFu::Record:0x007ff2dbbb0780 @data={"metric"=>:churn, "times_changed"=>36, "file_path"=>"metric_fu.gemspec"}, @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"]>, #<MetricFu::Record:0x007ff2dbbb02f8 @data={"metric"=>:churn, "times_changed"=>25, "file_path"=>"README.md"}, @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"]>, #<MetricFu::Record:0x007ff2dbbafee8 @data={"metric"=>:churn, "times_changed"=>19, "file_path"=>"TODO.md"}, @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"]>, #<MetricFu::Record:0x007ff2dbbafb78 @data={"metric"=>:churn, "times_changed"=>18, "file_path"=>"lib/metric_fu.rb"}, @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"]>, #<MetricFu::Record:0x007ff2dbbaf7b8 @data={"metric"=>:churn, "times_changed"=>16, "file_path"=>"Gemfile"}, @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"]>, #<MetricFu::Record:0x007ff2dbbaf560 @data={"metric"=>:churn, "times_changed"=>16, "file_path"=>"lib/configuration.rb"}, @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"]>, #<MetricFu::Record:0x007ff2dbbaf330 @data={"metric"=>:churn, "times_changed"=>16, "file_path"=>"lib/metric_fu/version.rb"}, @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"]>, #<MetricFu::Record:0x007ff2dbbaf0d8 @data={"metric"=>:churn, "times_changed"=>14, "file_path"=>"HISTORY.md"}, @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "


*****calling generate records
*****post generate record caller ["/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/hotspots/hotspot_analyzer.rb:63:in `each'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/hotspots/hotspot_analyzer.rb:63:in `setup'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/hotspots/hotspot_analyzer.rb:25:in `initialize'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/hotspots/hotspots.rb:11:in `new'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/hotspots/hotspots.rb:11:in `emit'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/generator.rb:129:in `block in generate_report'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/generator.rb:127:in `each'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/generator.rb:127:in `generate_report'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/reporting/report.rb:63:in `add'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/run.rb:25:in `block in run_reports'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/run.rb:23:in `each'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/run.rb:23:in `run_reports'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/run.rb:10:in `run'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/tasks/metric_fu.rake:5:in `block (2 levels) in <top (required)>'", "/Users/bfleischer/.rvm/gems/ruby-1.9.3-p194@metric_fu/bin/ruby_noexec_wrapper:14:in `eval'", "/Users/bfleischer/.rvm/gems/ruby-1.9.3-p194@metric_fu/bin/ruby_noexec_wrapper:14:in `<main>'"]






***post generate records caller ["/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/hotspots/hotspot_analyzer.rb:25:in `initialize'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/hotspots/hotspots.rb:11:in `new'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/hotspots/hotspots.rb:11:in `emit'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/generator.rb:129:in `block in generate_report'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/generator.rb:127:in `each'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/generator.rb:127:in `generate_report'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/reporting/report.rb:63:in `add'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/run.rb:25:in `block in run_reports'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/run.rb:23:in `each'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/run.rb:23:in `run_reports'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/run.rb:10:in `run'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/tasks/metric_fu.rake:5:in `block (2 levels) in <top (required)>'", "/Users/bfleischer/.rvm/gems/ruby-1.9.3-p194@metric_fu/bin/ruby_noexec_wrapper:14:in `eval'", "/Users/bfleischer/.rvm/gems/ruby-1.9.3-p194@metric_fu/bin/ruby_noexec_wrapper:14:in `<main>'"]
*****calculate_scores for rankings on tool_analyzers with granularities
*****granularities ["file_path", "class_name", "method_name"]
*****post granularities caller ["/Users/bfleischer/workspace/metric_

*****post granularities caller ["/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/hotspots/hotspot_analyzer.rb:25:in `initialize'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/hotspots/hotspots.rb:11:in `new'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/hotspots/hotspots.rb:11:in `emit'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/generator.rb:129:in `block in generate_report'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/generator.rb:127:in `each'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/metrics/generator.rb:127:in `generate_report'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/reporting/report.rb:63:in `add'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/run.rb:25:in `block in run_reports'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/run.rb:23:in `each'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/run.rb:23:in `run_reports'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/run.rb:10:in `run'", "/Users/bfleischer/workspace/metric_fu/lib/metric_fu/tasks/metric_fu.rake:5:in `block (2 levels) in <top (required)>'", "/Users/bfleischer/.rvm/gems/ruby-1.9.3-p194@metric_fu/bin/ruby_noexec_wrapper:14:in `eval'", "/Users/bfleischer/.rvm/gems/ruby-1.9.3-p194@metric_fu/bin/ruby_noexec_wrapper:14:in `<main>'"]
sub table
#<MetricFu::Table:0x007fe41c4cd968 @rows=[#<MetricFu::Record:0x007fe41dc33670 @data={"metric"=>:flog, "score"=>135.0794789188945, "file_path"=>"lib/metric_fu/core_ext/inflector/inflections.rb:54", "class_name"=>"Inflections", "method_name"=>"Inflections#irregular"}, @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"]>, #<MetricFu::Record:0x007fe41c341f40 @data={"metric"=>:saikuro, "lines"=>15, "complexity"=>2, "class_name"=>"Inflections", "method_name"=>"Inflections#irregular", "file_path"=>"lib/metric_fu/core_ext/inflector/inflections.rb:54"}, @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"]>], @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"], @make_index=true, @metric_index={:flog=>#<MetricFu::Table:0x007fe41c4cd0d0 @rows=[#<MetricFu::Record:0x007fe41dc33670 @data={"metric"=>:flog, "score"=>135.0794789188945, "file_path"=>"lib/metric_fu/core_ext/inflector/inflections.rb:54", "class_name"=>"Inflections", "method_name"=>"Inflections#irregular"}, @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"]>], @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"], @make_index=false, @metric_index={}>, :saikuro=>#<MetricFu::Table:0x007fe41c5c6ce8 @rows=[#<MetricFu::Record:0x007fe41c341f40 @data={"metric"=>:saikuro, "lines"=>15, "complexity"=>2, "class_name"=>"Inflections", "method_name"=>"Inflections#irregular", "file_path"=>"lib/metric_fu/core_ext/inflector/inflections.rb:54"}, @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"]>], @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"], @make_index=false, @metric_index={}>}>
rake aborted!
undefined method `rows' for #<MetricFu::Table:0x007fe41c4cd968>



  after_emit
  before_analyze
  analyze
      @hotspots = @analyzer && @analyzer.hotspots || {}
  after_analyze
  before_to_h
  to_h
      {:hotspots => @hotspots}


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

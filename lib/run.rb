MetricFu.lib_require { 'configuration' }
module MetricFu
  class Run
    def initialize
      STDOUT.sync = true
      MetricFu::Configuration.run do |config|
        config.roodi    = config.roodi.merge(:roodi_config => "#{MetricFu.root_dir}/config/roodi_config.yml")
        config.churn    = { :start_date => "1 year ago", :minimum_churn_count => 10}
        config.hotspots = { :start_date => "1 year ago", :minimum_churn_count => 10}
      end
    end
    def run
      add_metrics
      save_reports
      save_graphs
      display_results
    end
    def add_metrics
      MetricFu.metrics.each {|metric|
        mf_debug "** STARTING METRIC #{metric}"
        MetricFu.report.add(metric)
        mf_debug "** ENDING METRIC #{metric}"
      }
    end
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
    def save_graphs
      mf_debug "** PREPARING TO GRAPH"
      MetricFu.graphs.each {|graph|
        mf_debug "** Graphing #{graph} with #{MetricFu.graph_engine}"
        MetricFu.graph.add(graph, MetricFu.graph_engine)
      }
      mf_debug "** GENERATING GRAPH"
      MetricFu.graph.generate
    end
    def display_results
      if MetricFu.report.open_in_browser?
        mf_debug "** OPENING IN BROWSER FROM #{MetricFu.output_directory}"
        MetricFu.report.show_in_browser(MetricFu.output_directory)
      end
    end
  end
end


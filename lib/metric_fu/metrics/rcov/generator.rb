MetricFu.lib_require { "utility" }
MetricFu.lib_require { "calculate" }
MetricFu.data_structures_require { "line_numbers" }
require_relative "rcov_format_coverage"
require_relative "rcov_line"
require_relative "external_client"

module MetricFu
  class RcovGenerator < MetricFu::Generator
    def self.metric
      :rcov
    end

    def emit
      if run_rcov?
        mf_debug "** Running the specs/tests in the [#{options[:environment]}] environment"
        mf_debug "** #{command}"
        `#{command}`
      end
    end

    def command
      @command ||= default_command
    end

    def command=(command)
      @command = command
    end

    def reset_output_location
      MetricFu::Utility.rm_rf(metric_directory, verbose: false)
      MetricFu::Utility.mkdir_p(metric_directory)
    end

    def default_command
      require "rake"
      reset_output_location
      test_files = FileList[*options[:test_files]].join(" ")
      rcov_opts = options[:rcov_opts].join(" ")
      %(RAILS_ENV=#{options[:environment]} rcov #{test_files} #{rcov_opts} >> #{default_output_file})
    end

    def analyze
      rcov_text = load_output
      formatter = MetricFu::RCovFormatCoverage.new(rcov_text)
      @rcov = formatter.to_h
    end

    def to_h
      {
        rcov: @rcov
      }
    end

    private

    # We never run rcov anymore
    def run_rcov?
      false
    end

    def load_output
      MetricFu::RCovTestCoverageClient.new(output_file).load
    end

    def output_file
      options.fetch(:external)
    end

    # Only used if run_rcov? is true
    def default_output_file
      output_file || File.join(metric_directory, "rcov.txt")
    end
  end
end

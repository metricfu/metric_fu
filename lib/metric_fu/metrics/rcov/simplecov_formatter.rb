if defined?(JRUBY_VERSION)
  if ENV["JRUBY_OPTS"].to_s !~ /-Xcli.debug=true/
    warn "Coverage may be inaccurate; Try setting JRUBY_OPTS=\"-Xcli.debug=true --debug\""
    # see https://github.com/metricfu/metric_fu/pull/226
    #     https://github.com/jruby/jruby/issues/1196
    #     https://jira.codehaus.org/browse/JRUBY-6106
    #     https://github.com/colszowka/simplecov/issues/86
  end
end
require "simplecov"
require "metric_fu/logger"
require_relative "external_client"
require_relative "rcov_format_coverage"

class SimpleCov::Formatter::MetricFu
  def format(result)
    rcov_text = FormatLikeRCov.new(result).format
    client = MetricFu::RCovTestCoverageClient.new(coverage_file_path)
    client.post_results(rcov_text)
  end

  attr_writer :coverage_file_path

  def coverage_file_path
    @coverage_file_path || self.coverage_file_path = default_coverage_file_path
  end

  def default_coverage_file_path
    File.join(SimpleCov.root, "coverage", "rcov", output_file_name)
  end

  # TODO: Read in from legacy coverage/rcov/rcov.txt path, when set
  # write to date-specific report file, read from if present
  # e.g.
  #  MetricFu::Metric.get_metric(:rcov).run_options[:output_directory]
  #  or
  #  metric_directory = MetricFu::Io::FileSystem.scratch_directory('Ymd-coverage')
  #  MetricFu::Utility.mkdir_p(metric_directory, :verbose => false)
  # @note legacy file name is 'rcov.txt'
  #   going forward, the file name will be in a date-stamped
  #   format like for all other reported metrics.
  def output_file_name
    "rcov.txt"
  end

  # report should reference file used to build it
  class FormatLikeRCov
    def initialize(result)
      @result = result
    end

    def format
      content = "metric_fu shift the first line\n"
      @result.source_files.each do |source_file|
        content << "=" * 80
        content << "\n #{simple_file_name(source_file)}\n"
        content << "=" * 80
        content << "\n"
        source_file.lines.each do |line|
          content << "!!" if line.missed?
          content << "--" if line.never? || line.skipped?
          content << "  " if line.covered?
          content << " #{line.src.chomp}\n"
        end
        content << "\n"
      end
      content
    end

    def simple_file_name(source_file)
      source_file.filename.gsub(SimpleCov.root, ".")
    end
  end
end

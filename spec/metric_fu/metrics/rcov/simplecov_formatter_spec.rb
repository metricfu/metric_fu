require "spec_helper"
require "simplecov"
require "metric_fu/metrics/rcov/simplecov_formatter"
require "metric_fu/metrics/rcov/generator"

describe SimpleCov::Formatter::MetricFu do
  before do
    @rcov_file =  subject.coverage_file_path
    File.delete(@rcov_file) if File.exists?(@rcov_file)

    @result = SimpleCov::Result.new(

       FIXTURE.fixtures_path.join("coverage.rb").expand_path.to_s =>
        [1, 1, 1, 1, nil, 1, 0, 1, 1, nil, 0, 1, 1]

    )
  end

  it "test_format" do
    SimpleCov::Formatter::MetricFu.new.format(@result)

    expect(File.exists?(@rcov_file)).to be_truthy
  end

  if SimpleCov.running
    MetricFu.logger.info "Skipping specs while SimpleCov is running"
  else
    it "test_create_content" do
      content = SimpleCov::Formatter::MetricFu::FormatLikeRCov.new(@result).format
      test = "\=" * 80

      expect(content).to match(/#{test}/)
      expect(content).to match(/!!     value \* value/)
    end

    if defined?(JRUBY_VERSION)
      STDOUT.puts "Skipping spec 'cause JRuby doesn't do Coverage right"
    else
      it "calculates the same coverage from an RCov report as from SimpleCov" do
        SimpleCov.start # start coverage
        require "fixtures/coverage-153"
        result = SimpleCov.result # end coverage
        source_file = result.source_files.first

        # formatter ouputs this from simplecov result
        rcov_text = SimpleCov::Formatter::MetricFu::FormatLikeRCov.new(result).format

        # generator analyzes the rcov text
        analyzed_rcov_text = MetricFu::RCovFormatCoverage.new(rcov_text).to_h
        # [:lines, :percent_run, :methods]
        covered_lines_from_rcov_text = analyzed_rcov_text["./spec/fixtures/coverage-153.rb"][:lines]
        # https://github.com/colszowka/simplecov/blob/master/lib/simplecov/source_file.rb
        expect(source_file.coverage.count).to eq(covered_lines_from_rcov_text.count)

        line_coverage_from_rcov_text = covered_lines_from_rcov_text.map { |line| line[:was_run] }
        expect(source_file.coverage).to eq(line_coverage_from_rcov_text)

        expect(source_file.covered_percent).to eq(MetricFu::RCovFormatCoverage::TestCoverage.percent_run(covered_lines_from_rcov_text))

        source_file.lines.each_with_index do |line, index|
          expect(line.coverage).to eq(line_coverage_from_rcov_text[index])
        end
      end
    end

  end
end

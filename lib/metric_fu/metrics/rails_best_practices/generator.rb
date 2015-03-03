module MetricFu
  class RailsBestPracticesGenerator < Generator
    def self.metric
      :rails_best_practices
    end

    def emit
      mf_debug "** Rails Best Practices"
      path = "."
      analyzer = ::RailsBestPractices::Analyzer.new(path,  "silent" => true)
      analyzer.analyze
      @output = analyzer.errors
    end

    def analyze
      @problems = @output.collect do |problem|
        {
          file: problem.filename,
          line: problem.line_number,
          problem: problem.message,
          url: problem.url
        }
      end
      total = ["Found #{@problems.count} errors."]
      @rails_best_practices_results = { total: total, problems: @problems }
    end

    def to_h
      { rails_best_practices: @rails_best_practices_results }
    end

    def per_file_info(out)
      @rails_best_practices_results[:problems].each do |problem|
        next if problem[:file] == "" || problem[:problem].nil?

        lines = problem[:line].split(/\s*,\s*/)
        lines.each do |line|
          out[problem[:file]][line] << { type: :rails_best_practices, description: problem[:problem] }
        end
      end
    end
  end
end

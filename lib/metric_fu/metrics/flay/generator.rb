module MetricFu

  class FlayGenerator < Generator

    def self.metric
      :flay
    end

    def emit
      @output = run(options)
    end

    def analyze
      @matches = @output.chomp.split("\n\n").map{|m| m.split("\n  ") }
    end

    def to_h
      {:flay => calculate_result(@matches)}
    end

    # TODO: move into analyze method
    def calculate_result(matches)
      total_score = matches.shift.first.split('=').last.strip
      target = []
      matches.each do |problem|
        reason = problem.shift.strip
        lines_info = problem.map do |full_line|
          name, line = full_line.split(":").map(&:strip)
          {:name => name, :line => line}
        end
        target << [:reason => reason, :matches => lines_info]
      end
      {
        :total_score => total_score,
        :matches => target.flatten
      }
    end

    def run(options)
      flay_options = Flay.default_options.merge(minimum_duplication_mass)
      flay = Flay.new flay_options
      files = Flay.expand_dirs_to_files(dirs_to_flay)
      flay.process(*files)
      MetricFu::Utility.capture_output do
         flay.report
      end
    end

    private

    def minimum_duplication_mass
      flay_mass = options[:minimum_score]
      return {} unless flay_mass


      {:mass => flay_mass}
    end

    def dirs_to_flay
      options[:dirs_to_flay]
    end

  end
end

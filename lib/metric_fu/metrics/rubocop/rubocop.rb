require 'json'

module MetricFu
  class RubocopGenerator < Generator

    def self.metric
      :rubocop
    end

    def emit
      mf_debug "** Rubocop"
      command = %Q{#{config_param} #{dirs_param}}
      mf_debug "** #{command}"
      @output = `rubocop --format json #{config_param} #{dirs_param}`
    end

    def analyze
      problems = JSON.parse(@output)
      @problems = problems["files"].collect do |problem|
        { file: problem["path"],
          offences: problem["offences"]
        }
      end
      @summary = problems["summary"]
    end

    def config_param
      options[:config] ? "--config #{options[:config]}" : ""
    end

    def dirs_param
      options[:dirs_to_rubocop] ? "#{options[:dirs_to_rubocop].join(" ")}" : ""
    end

    def to_h
      {rubocop: { problems: @problems , summary: @summary}}
    end

  end
end
module MetricFu
  class ReekGenerator < Generator
    REEK_REGEX = /^(\S+) (.*) \((.*)\)$/

    def self.metric
      :reek
    end

    def emit
      files = files_to_analyze
      if files.empty?
        mf_log "Skipping Reek, no files found to analyze"
        @output = ""
      else
        args = cli_options(files)
        @output = run!(args)
        @output = massage_for_reek_12 if reek_12?
      end
    end

    def run!(args)
      require "reek/cli/application"

      MetricFu::Utility.capture_output do
        Reek::Cli::Application.new(args).execute
      end
    end

    def analyze
      @matches = @output.chomp.split("\n\n").map { |m| m.split("\n") }
      @matches = @matches.map do |match|
        break {} if zero_warnings?(match)
        file_path = match.shift.split(" -- ").first
        file_path = file_path.gsub('"', " ").strip
        code_smells = match.map do |smell|
          match_object = smell.match(REEK_REGEX)
          next unless match_object
          { method: match_object[1].strip,
            message: match_object[2].strip,
            type: match_object[3].strip }
        end.compact
        { file_path: file_path, code_smells: code_smells }
      end
    end

    def to_h
      { reek: { matches: @matches } }
    end

    def per_file_info(out)
      @matches.each do |file_data|
        file_path = file_data[:file_path]
        next if File.extname(file_path) =~ /\.erb|\.html|\.haml/
        begin
          line_numbers = MetricFu::LineNumbers.new(File.read(file_path), file_path)
        rescue StandardError => e
          raise e unless e.message =~ /you shouldn't be able to get here/
          mf_log "ruby_parser blew up while trying to parse #{file_path}. You won't have method level reek information for this file."
          next
        end

        file_data[:code_smells].each do |smell_data|
          line = line_numbers.start_line_for_method(smell_data[:method])
          out[file_data[:file_path]][line.to_s] << { type: :reek,
                                                     description: "#{smell_data[:type]} - #{smell_data[:message]}" }
        end
      end
    end

    def reek_12?
      return false if @output.length == 0
      (@output =~ /^"/) != 0
    end

    def massage_for_reek_12
      section_break = ""
      @output.split("\n").map do |line|
        case line
        when /^  /
          "#{line.gsub(/^  /, '')}\n"
        else
          parts = line.split(" -- ")
          if parts[1].nil?
            "#{line}\n"
          else
            warnings = parts[1].gsub(/ \(.*\):/, ":")
            result = "#{section_break}\"#{parts[0]}\" -- #{warnings}\n"
            section_break = "\n"
            result
          end
        end
      end.join
    end

    private

    def files_to_analyze
      dirs_to_reek = options[:dirs_to_reek]
      files_to_reek = dirs_to_reek.map { |dir| Dir[File.join(dir, "**", "*.rb")] }.flatten
      remove_excluded_files(files_to_reek)
    end

    def cli_options(files)
      [
        disable_line_number_option,
        turn_off_color,
        *config_option,
        *files
      ].reject(&:empty?)
    end

    # TODO: Check that specified line config file exists
    def config_option
      config_file_pattern =  options[:config_file_pattern]
      if config_file_pattern.to_s.empty?
        [""]
      else
        ["--config", config_file_pattern]
      end
    end

    # Work around "Error: invalid option: --no-color" in reek < 1.3.7
    def turn_off_color
      if reek_version >= "1.3.7"
        "--no-color"
      else
        ""
      end
    end

    def reek_version
      @reek_version ||=  `reek --version`.chomp.sub(/\s*reek\s*/, "")
      # use the above, as the below may activate a version not available in
      # a Bundler context
      # MetricFu::GemVersion.activated_version('reek').to_s
    end

    def disable_line_number_option
      "--no-line-numbers"
    end

    def zero_warnings?(match)
      match.last == "0 total warnings"
    end
  end
end

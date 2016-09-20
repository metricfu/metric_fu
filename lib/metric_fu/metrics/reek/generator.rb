module MetricFu
  class ReekGenerator < Generator
    def self.metric
      :reek
    end

    def emit
      files = files_to_analyze
      if files.empty?
        mf_log "Skipping Reek, no files found to analyze"
        run!([], config_files)
      else
        run!(files, config_files)
      end
    end

    def run!(files, config_files)
      examiner.run!(files, config_files)
    end

    def analyze
      @matches = examiner.analyze
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

    private

    def files_to_analyze
      dirs_to_reek = options[:dirs_to_reek]
      files_to_reek = dirs_to_reek.map { |dir| Dir[File.join(dir, "**", "*.rb")] }.flatten
      remove_excluded_files(files_to_reek)
    end

    # TODO: Check that specified line config file exists
    def config_files
      Array(options[:config_file_pattern])
    end

    def examiner
      @examiner ||= begin
        require "reek"
        # To load any changing dependencies such as "reek/configuration/app_configuration"
        #   Added in 1.6.0 https://github.com/troessner/reek/commit/7f4ed2be442ca926e08ccc41945e909e8f710947
        #   But not always loaded
        require "reek/cli/application"

        klass = Reek.const_defined?(:Examiner) ? Reek.const_get(:Examiner) : Reek.const_get(:Core).const_get(:Examiner)

        case Gem::Version.new(Reek::Version::STRING).segments.first
        when 1, 2
          ReekExaminerV1.new(klass)
        when 3
          ReekExaminerV3.new(klass)
        else
          ReekExaminerV4.new(klass)
        end
      end
    end
  end

  class ReekExaminerV1
    def initialize(examiner)
      @examiner = examiner
    end

    def run!(files, config_files)
      @output = @examiner.new(files, config_files)
    end

    def analyze
      @output.smells.group_by(&:source).collect do |file_path, smells|
        { file_path: file_path,
          code_smells: analyze_smells(smells) }
      end
    end

    private

    def analyze_smells(smells)
      smells.collect(&method(:smell_data))
    end

    def smell_data(smell)
      { method: smell.context,
        message: smell.message,
        type: smell_type(smell),
        lines: smell.lines }
    end

    def smell_type(smell)
      return smell.subclass if smell.respond_to?(:subclass)
      smell.smell_type
    end

  end

  class ReekExaminerV3 < ReekExaminerV1
    def run!(files, config_files)
      @output = files.map { |file| 
        @examiner.new(Pathname.new(file), config_files) 
      }
    end

    def analyze
      @output.map(&:smells).flatten.group_by(&:source).collect do |file_path, smells|
        { file_path: file_path,
          code_smells: analyze_smells(smells) }
      end
    end
  end

  class ReekExaminerV4 < ReekExaminerV3
    def run!(files, config_files)
      @output = files.map { |file| 
        @examiner.new(Pathname.new(file), filter_by_smells: config_files) 
      }
    end
  end

end

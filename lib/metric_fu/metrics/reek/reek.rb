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
        command = %Q(mf-reek #{cli_options(files)})
        mf_debug "** #{command}"
        @output = `#{command}`
        @output = massage_for_reek_12 if reek_12?
      end
    end


    def analyze
      @matches = @output.chomp.split("\n\n").map{|m| m.split("\n") }
      @matches = @matches.map do |match|
        file_path = match.shift.split('--').first
        file_path = file_path.gsub('"', ' ').strip
        code_smells = match.map do |smell|
          match_object = smell.match(REEK_REGEX)
          next unless match_object
          {:method => match_object[1].strip,
           :message => match_object[2].strip,
           :type => match_object[3].strip}
        end.compact
        {:file_path => file_path, :code_smells => code_smells}
      end
    end

    def to_h
      {:reek => {:matches => @matches}}
    end

    def per_file_info(out)
      @matches.each do |file_data|
        file_path = file_data[:file_path]
        next if File.extname(file_path) =~ /\.erb|\.html|\.haml/
        begin
          line_numbers = MetricFu::LineNumbers.new(File.open(file_path, 'r').read,file_path)
        rescue StandardError => e
          raise e unless e.message =~ /you shouldn't be able to get here/
          mf_log "ruby_parser blew up while trying to parse #{file_path}. You won't have method level reek information for this file."
          next
        end

        out[file_data[:file_path]] ||= {}
        file_data[:code_smells].each do |smell_data|
          line = line_numbers.start_line_for_method(smell_data[:method])
          out[file_data[:file_path]][line.to_s] ||= []
          out[file_data[:file_path]][line.to_s] << {:type => :reek,
                                                    :description => "#{smell_data[:type]} - #{smell_data[:message]}"}
        end
      end
    end

    def reek_12?
      return false if @output.length == 0
      (@output =~ /^"/) != 0
    end

    def massage_for_reek_12
      section_break = ''
      @output.split("\n").map do |line|
        case line
        when /^  /
          "#{line.gsub(/^  /, '')}\n"
        else
          parts = line.split(" -- ")
          if parts[1].nil?
            "#{line}\n"
          else
            warnings = parts[1].gsub(/ \(.*\):/, ':')
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
      files_to_reek = dirs_to_reek.map{|dir| Dir[File.join(dir, "**","*.rb")] }.flatten
      remove_excluded_files(files_to_reek)
    end

    def cli_options(files)
      config_file_param = options[:config_file_pattern] ? "--config #{options[:config_file_pattern]}" : ''
      cli_options = "#{config_file_param} #{files.join(' ')}"
    end

  end
end

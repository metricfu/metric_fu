MetricFu.metrics_require   { "saikuro/parsing_element" }
module MetricFu
  class SaikuroScratchFile
    def self.assemble_files(glob)
      files = []
      glob.each do |path|
        if is_valid_text_file?(path)
          file = new(path)
          if file
            files << file
          end
        end
      end
      files
    end

    attr_reader :elements

    def initialize(path)
      @path = path
      @elements = []
      File.open(@path, "rb") do |file|
        get_elements(file)
      end
    end

    def self.is_valid_text_file?(path)
      File.open(path, "rb") do |file|
        if file.eof? || !file.readline.match(/--/)
          return false
        else
          return true
        end
      end
    end

    def filename
      File.basename(@path, "_cyclo.html")
    end

    def filepath
      File.dirname(@path)
    end

    def to_h
      merge_classes
      { classes: @elements }
    end

    def get_elements(io)
      while (line = io.readline)
        return [] if line.nil? || line !~ /\S/
        element ||= nil
        if line.match(/START/)
          unless element.nil?
            @elements << element
            element = nil
          end
          line = io.readline
          element = MetricFu::SaikuroParsingElement.new(line)
        elsif line.match(/END/)
          @elements << element if element
          element = nil
        else
          element << line if element
        end
      end
    rescue EOFError
      nil
    end

    def merge_classes
      new_elements = []
      get_class_names.each do |target_class|
        elements = @elements.find_all { |el| el.name == target_class }
        complexity = 0
        lines = 0
        defns = []
        elements.each do |el|
          complexity += el.complexity.to_i
          lines += el.lines.to_i
          defns << el.defs
        end

        new_element = { class_name: target_class,
                        complexity: complexity,
                        lines: lines,
                        methods: defns.flatten.map(&:to_h) }
        new_element[:methods] = new_element[:methods].
                                sort_by { |x| x[:complexity] }.
                                reverse

        new_elements << new_element
      end
      @elements = new_elements if new_elements
    end

    def get_class_names
      class_names = []
      @elements.each do |element|
        unless class_names.include?(element.name)
          class_names << element.name
        end
      end
      class_names
    end
  end
end

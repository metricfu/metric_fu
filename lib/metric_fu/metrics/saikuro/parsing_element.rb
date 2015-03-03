module MetricFu
  class SaikuroParsingElement
    TYPE_REGEX = /Type:(.*) Name/
    NAME_REGEX = /Name:(.*) Complexity/
    COMPLEXITY_REGEX = /Complexity:(.*) Lines/
    LINES_REGEX = /Lines:(.*)/

    attr_reader :complexity, :lines, :defs, :element_type
    attr_accessor :name

    def initialize(line)
      @line = line
      @element_type = line.match(TYPE_REGEX)[1].strip
      @name = line.match(NAME_REGEX)[1].strip
      @complexity = line.match(COMPLEXITY_REGEX)[1].strip
      @lines = line.match(LINES_REGEX)[1].strip
      @defs = []
    end

    def <<(line)
      @defs << MetricFu::SaikuroParsingElement.new(line)
    end

    def to_h
      base = { name: @name, complexity: @complexity.to_i, lines: @lines.to_i }
      unless @defs.empty?
        defs = @defs.map do |my_def|
          my_def = my_def.to_h
          my_def.delete(:defs)
          my_def
        end
        base[:defs] = defs
      end
      base
    end
  end
end

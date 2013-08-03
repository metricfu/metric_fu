require 'optparse'
module MetricFu
  module Cli
    # see https://github.com/florianpilz/CLI-Option-Parser-Examples
    # https://raw.github.com/florianpilz/micro-optparse/master/lib/micro-optparse/parser.rb
    module MicroOptParse
      class Parser
        attr_accessor :banner, :version
        def initialize
          @options = []
          @used_short = []
          @default_values = nil
          yield self if block_given?
        end

        def option(name, desc, settings = {})
          @options << [name, desc, settings]
        end

        def short_from(name)
          name.to_s.chars.each do |c|
            next if @used_short.include?(c) || c == "_"
            return c # returns from short_from method
          end
        end

        def process!(arguments = ARGV)
          @result = (@default_values || {}).clone # reset or new
          @optionparser ||= OptionParser.new do |p| # prepare only once
            @options.each do |o|
              @used_short << short = o[2][:short] || short_from(o[0])
              @result[o[0]] = o[2][:default] || false # set default
              klass = o[2][:default].class == Fixnum ? Integer : o[2][:default].class

              if [TrueClass, FalseClass, NilClass].include?(klass) # boolean switch
                p.on("-" << short, "--[no-]" << o[0].to_s.gsub("_", "-"), o[1]) {|x| @result[o[0]] = x}
              else # argument with parameter
                p.on("-" << short, "--" << o[0].to_s.gsub("_", "-") << " " << o[2][:default].to_s, klass, o[1]) {|x| @result[o[0]] = x}
              end
            end

            p.on("--format FORMAT",
                 "Specify the formatter to use for output.",
                 "This option can be specified multiple times.",
                 "Specify a built-in formatter from the list below,",
                 "or the fully-qualified class name of your own custom formatter.",
                 *format_descriptions) do |f|
              @result[:format] ||= []
              @result[:format] << [f]
            end

            p.on("--out FILE|DIR",
                "Specify the file or directory to use for output",
                "This option applies to the previously",
                "specified --format, or the default format",
                "if no format is specified. Paths are relative to",
                "#{Pathname.pwd.join(MetricFu::Io::FileSystem.directory('base_directory'))}",
                "Check the specific formatter\'s docs to see",
                "whether to pass a file or a dir.") do |o|
              @result[:format] ||= MetricFu::Formatter::DEFAULT
              @result[:format].last << o
            end

            p.banner = @banner unless @banner.nil?
            p.on_tail("-h", "--help", "Show this message") {puts p ; exit}
            short = @used_short.include?("v") ? "-V" : "-v"
            p.on_tail(short, "--version", "Print version") {puts @version ; exit} unless @version.nil?
            @default_values = @result.clone # save default values to reset @result in subsequent calls
          end

          begin
            @optionparser.parse!(arguments)
          rescue OptionParser::ParseError => e
            puts e.message ; exit(1)
          end

          validate(@result) if self.respond_to?("validate")
          @result
        end

        # Build a nicely formatted list of built-in
        # formatter keys and their descriptions
        # @see MetricFu::Formatter::BUILTIN_FORMATS
        # @example
        #    format_descriptions #=> ["  yaml :  Generates the raw output as yaml"]
        # @return [Array<String>] in the form of
        #    "   <key>  : <description>."
        def format_descriptions
          formats = MetricFu::Formatter::BUILTIN_FORMATS
          max = formats.keys.map{|s| s.length}.max
          formats.keys.sort.map do |key|
            "  #{key}#{' ' * (max - key.length)} : #{formats[key][1]}"
          end
        end
      end
    end

  end
end

require "optparse"
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

        def process!(arguments = ARGV)
          parser = build_option_parser
          process_options(parser, arguments)
        end

        def option(name, desc, settings = {})
          @options << [name, desc, settings]
        end

        private

        def build_option_parser
          @result = (@default_values || {}).clone # reset or new

          @optionparser ||= OptionParser.new do |p| # prepare only once
            configure_options(p)
          end
        end

        def process_options(parser, arguments)
          begin
            parser.parse!(arguments)
          rescue OptionParser::ParseError => e
            puts e.message
            MetricFu::Cli.immediate_shutdown!
          end

          @result
        end

        def configure_options(p)
          add_general_options(@options, p)

          add_format_option(p)
          add_output_option(p)

          p.banner = @banner unless @banner.nil?
          p.on_tail("-h", "--help", "Show this message") { puts p; success! }
          short = @used_short.include?("v") ? "-V" : "-v"
          p.on_tail(short, "--version", "Print version") { puts @version; success! } unless @version.nil?
          p.on_tail("--debug-info", "Print debug info") { debug_info; success! }
          @default_values = @result.clone # save default values to reset @result in subsequent calls
        end

        def add_general_options(options, p)
          options.each do |o|
            add_general_option(p, o)
          end
        end

        def add_general_option(p, o)
          @used_short << short = o[2][:short] || short_from(o[0])
          @result[o[0]] = o[2][:default] || false # set default
          klass = o[2][:default].class == Fixnum ? Integer : o[2][:default].class

          if [TrueClass, FalseClass, NilClass].include?(klass) # boolean switch
            p.on("-" << short, "--[no-]" << o[0].to_s.gsub("_", "-"), o[1]) { |x| @result[o[0]] = x }
          else # argument with parameter
            p.on("-" << short, "--" << o[0].to_s.gsub("_", "-") << " " << o[2][:default].to_s, klass, o[1]) { |x| @result[o[0]] = x }
          end
        end

        def add_output_option(p)
          p.on("--out FILE|DIR",
               "Specify the file or directory to use for output",
               "This option applies to the previously",
               "specified --format, or the default format",
               "if no format is specified. Paths are relative to",
               "#{MetricFu.run_path.join(MetricFu::Io::FileSystem.directory('base_directory'))}",
               "Check the specific formatter\'s docs to see",
               "whether to pass a file or a dir.") do |o|
            @result[:format] ||= MetricFu::Formatter::DEFAULT
            @result[:format].last << o
          end
        end

        def add_format_option(p)
          p.on("--format FORMAT",
               "Specify the formatter to use for output.",
               "This option can be specified multiple times.",
               "Specify a built-in formatter from the list below,",
               "or the fully-qualified class name of your own custom formatter.",
               *format_descriptions) do |f|
            @result[:format] ||= []
            @result[:format] << [f]
          end
        end

        def short_from(name)
          name.to_s.chars.each do |c|
            next if @used_short.include?(c) || c == "_"
            return c # returns from short_from method
          end
        end

        def debug_info
          extend(MetricFu::Environment)
          require "pp"
          pp debug_info
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
          max = formats.keys.map(&:length).max
          formats.keys.sort.map do |key|
            "  #{key}#{' ' * (max - key.length)} : #{formats[key][1]}"
          end
        end

        def success!
          MetricFu::Cli.complete!
        end
      end
    end
  end
end

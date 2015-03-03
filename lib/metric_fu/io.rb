MetricFu.lib_require { "utility" }
module MetricFu
  module Io
    # TODO: Move this module / functionality elsewhere and make less verbose
    module FileSystem
      # TODO: Use a better environmental variable name for the output / artiface dir.  Set to a different default in tests.
      @default_artifact_dir = "tmp/metric_fu"
      def self.default_artifact_dir
        @default_artifact_dir
      end
      def self.artifact_dir
        (ENV["CC_BUILD_ARTIFACTS"] || @artifact_dir)
      end
      def self.artifact_dir=(artifact_dir)
        @artifact_dir = artifact_dir
      end
      self.artifact_dir = default_artifact_dir

      module_function

      def directories
        @directories ||= {}
      end

      def directory(name)
        directories.fetch(name) { raise "No such directory configured: #{name}" }
      end

      def scratch_directory(name)
        File.join(directory("scratch_directory"), name.to_s)
      end

      def file_globs_to_ignore
        @file_globs_to_ignore ||= []
      end

      def set_directories
        @directories = {}
        @directories["base_directory"]    = MetricFu.artifact_dir
        @directories["scratch_directory"] = MetricFu.scratch_dir
        @directories["output_directory"]  = MetricFu.output_dir
        @directories["data_directory"]    = MetricFu.data_dir
        create_directories @directories.values

        @directories["root_directory"]    = MetricFu.root_dir
        # TODO Though this is true of the general AwesomeTemplate, it is not necessarily true of templates within each Metric.  Each metric should probably know how to use AwesomeTemplate (or whatever)
        @directories["template_directory"] = File.join(@directories.fetch("root_directory"), "lib", "templates")
        @file_globs_to_ignore = []
        set_code_dirs
      end

      def create_directories(*dirs)
        # due to behavior differences between ruby 1.8.7 and 1.9.3
        # this is good enough for now
        Array(*dirs).each do |dir|
          MetricFu::Utility.mkdir_p dir
        end
      end

      # Add the 'app' directory if we're running within rails.
      def set_code_dirs
        @directories["code_dirs"] = %w(app lib).select { |dir| Dir.exists?(dir) }
      end
    end

    # Writes the output to a file or io stream.
    # @param output [String, #to_s] the content to write.
    # @param path_or_io [String, #to_s, IO, #write] a file path
    #   or an io stream that responds to write.
    # @return [nil]
    def write_output(output, path_or_io)
      io_for(path_or_io) do |io|
        io.write(output)
      end
    end

    # Yields an io object for writing output.
    # @example
    #   io_for('path/to/file') do |io|
    #     io.write(output)
    #   end
    #
    #   io_for(STDOUT) do |io|
    #     io.write(output)
    #   end
    #
    #   stream = StringIO.new
    #   io_for(stream) do |io|
    #     io.write(output)
    #   end
    #
    # @param path_or_io [String, #to_s, IO, #write] a file path
    #   or an io stream that responds to write.
    #
    # @yield [IO] an open stream for writing.
    #
    # @note Given a path to a file, an open file will
    #   be yielded and closed after the block completes.
    #   Given an existing io stream, the stream will not
    #   be automatically closed. Cleanup, if necessary, is
    #   the responsibility of the caller.
    def io_for(path_or_io, &block)
      raise ArgumentError, "No path or io provided." if path_or_io.nil?
      raise ArgumentError, "No block given. Cannot yield io stream." unless block_given?

      if path_or_io.respond_to?(:write)
        # We have an existing open stream...
        block.call(path_or_io)
      else # Otherwise, we assume its a file path...
        file_for(path_or_io, &block)
      end
    end

    def file_for(path, &block)
      File.open(path_relative_to_base(path), "w") do |file|
        block.call(file)
      end
    end

    def dir_for(path)
      return nil if path.nil?
      pathname = path_relative_to_base(path)
      MetricFu::Utility.mkdir_p(pathname) unless File.directory?(pathname)
      pathname
    end

    def path_relative_to_base(path)
      pathname = MetricFu.run_path.join(MetricFu::Io::FileSystem.directory("base_directory")) # make full path relative to base directory
      pathname.join(path)
    end
  end
end

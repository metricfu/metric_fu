require 'fileutils'
module MetricFu
  module Io
    # TODO: Move this module / functionality elsewhere and make less verbose
    module FileSystem

      # TODO: Use a better environmental variable name for the output / artiface dir.  Set to a different default in tests.
      def self.artifact_dir
        (ENV['CC_BUILD_ARTIFACTS'] || 'tmp/metric_fu')
      end

      module_function

      def directories
        @directories ||= {}
      end

      def directory(name)
        directories.fetch(name) { raise "No such directory configured: #{name}" }
      end
      def file_globs_to_ignore
        @file_globs_to_ignore ||= []
      end

      # TODO: Remove call to config
      def set_directories(config)
        @directories = {}
        @directories['base_directory']    = MetricFu.artifact_dir
        @directories['scratch_directory'] = MetricFu.scratch_dir
        @directories['output_directory']  = MetricFu.output_dir
        @directories['data_directory']    = MetricFu.data_dir
        create_directories @directories.values

        @directories['root_directory']    = MetricFu.root_dir
        # TODO Though this is true of the general AwesomeTemplate, it is not necessarily true of templates within each Metric.  Each metric should probably know how to use AwesomeTemplate (or whatever)
        @directories['template_directory'] = File.join(@directories.fetch('root_directory'), 'lib', 'templates')
        @file_globs_to_ignore = []
        set_code_dirs(config)
      end

      def create_directories(*dirs)
        # due to behavior differences between ruby 1.8.7 and 1.9.3
        # this is good enough for now
        Array(*dirs).each do |dir|
          FileUtils.mkdir_p dir
        end
      end

      # Add the 'app' directory if we're running within rails.
      def set_code_dirs(config)
        @directories['code_dirs'] = %w(app lib).select do |dir|
          Dir.exists? dir
        end
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
    def io_for(path_or_io)
      raise ArgumentError, "No path or io provided." if path_or_io.nil?
      raise ArgumentError, "No block given. Cannot yield io stream." unless block_given?

      if path_or_io.respond_to?(:write)
        # We have an existing open stream...
        yield path_or_io
      else # Otherwise, we assume its a file path...
        file_for(path_or_io) {|io| yield io }
      end
    end

    def file_for(path)
      File.open(path_relative_to_base(path), 'w') do |file|
        yield file
      end
    end

    def dir_for(path)
      return nil if path.nil?
      pathname = path_relative_to_base(path)
      FileUtils.mkdir_p(pathname) unless File.directory?(pathname)
      pathname
    end

    def path_relative_to_base(path)
      pathname = Pathname.pwd.join(MetricFu::Io::FileSystem.directory('base_directory')) # make full path relative to base directory
      pathname.join(path)
    end
  end
end

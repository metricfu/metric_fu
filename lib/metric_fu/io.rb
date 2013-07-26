module MetricFu
  module Io
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
      pathname = Pathname.pwd.join(MetricFu.base_directory) # make full path relative to base directory
      pathname.join(path)
    end
  end
end

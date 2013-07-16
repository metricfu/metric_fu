module MetricFu
  module Io
    def io_for(path_or_io)
      return nil if path_or_io.nil?
      return path_or_io if path_or_io.respond_to?(:write)

      # Otherwise, we assume its a file path...
      file = File.open(path_relative_to_base(path_or_io), "w")
      at_exit do
        unless file.closed?
          file.flush
          file.close
        end
      end
      file
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

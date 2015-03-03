# Reads and writes external coverage files as BINARY
module MetricFu
  class RCovTestCoverageClient
    def initialize(coverage_file)
      @file_path = Pathname(coverage_file)
      @file_path.dirname.mkpath
    end

    def post_results(payload)
      mf_log "Saving coverage payload to #{@file_path}"
      dump(payload)
    end

    def load
      File.binread(@file_path)
    end

    def dump(payload)
      File.open(@file_path, "wb") { |file| file.write(payload) }
    end
  end
end

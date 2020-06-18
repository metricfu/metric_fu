# https://raw.githubusercontent.com/metric_fu/metric_fu/master/spec/capture_warnings.rb
require "rubygems" if RUBY_VERSION =~ /^1\.8/
require "bundler/setup"
require "rspec/core"
require "rspec/expectations"
require "tempfile"
require "fileutils"

stderr_file = Tempfile.new("app.stderr")
app_root ||= Dir.pwd
output_dir = File.join(app_root, "tmp")
FileUtils.mkdir_p(output_dir)
bundle_dir = File.join(app_root, "bundle")

RSpec.configure do |config|
  config.before(:suite) do
    $stderr.reopen(stderr_file.path)
    $VERBOSE = true
  end

  config.after(:suite) do
    stderr_file.rewind
    lines = stderr_file.read.split("\n").uniq
    stderr_file.close!

    $stderr.reopen(STDERR)

    app_warnings, other_warnings = lines.partition { |line|
      line.include?(app_root) && !line.include?(bundle_dir)
    }

    if other_warnings.any?
      output_file = File.join(output_dir, "warnings.txt")
      File.write(output_file, other_warnings.join("\n") << "\n")
      puts
      puts "Non-app warnings written to tmp/warnings.txt"
      puts
    end

    if app_warnings.any?
      puts <<-WARNINGS

#{'-' * 30} app warnings: #{'-' * 30}

#{app_warnings.join("\n")}

#{'-' * 75}

      WARNINGS

      abort "Failing build due to app warnings: #{app_warnings.inspect}"
    end
  end
end

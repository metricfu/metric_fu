# https://raw.githubusercontent.com/metric_fu/metric_fu/master/spec/capture_warnings.rb
require "rubygems" if RUBY_VERSION =~ /^1\.8/
require "bundler/setup"
require "rspec/core"
require "rspec/expectations"
require "tempfile"
require "fileutils"

stderr_file = Tempfile.new("app.stderr")
app_dir = File.expand_path("../..", __FILE__)
output_dir = File.join(app_dir, "tmp")
FileUtils.mkdir_p(output_dir)
bundle_dir = File.join(app_dir, "bundle")

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

    app_warnings, other_warnings = lines.partition do |line|
      line.include?(app_dir) && !line.include?(bundle_dir)
    end

    if app_warnings.any?
      puts <<-WARNINGS
#{'-' * 30} app warnings: #{'-' * 30}

#{app_warnings.join("\n")}

#{'-' * 75}
      WARNINGS
    end

    if other_warnings.any?
      File.write(File.join(output_dir, "warnings.txt"), other_warnings.join("\n") << "\n")
      puts
      puts "Non-app warnings written to tmp/warnings.txt"
      puts
    end

    # fail the build...
    abort "Failing build due to app warnings: #{app_warnings.inspect}" if app_warnings.any?
  end
end

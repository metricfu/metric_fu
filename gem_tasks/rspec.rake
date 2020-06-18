begin
  Rake::Task[:spec].clear if Rake::Task.task_defined?(:spec)
  require "rspec/core/rake_task"
rescue LoadError
else
  desc "Run all specs in spec directory"
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.verbose = false

    t.pattern = "spec/**/*_spec.rb"
    # we require spec_helper so we don't get an RSpec warning about
    # examples being defined before configuration.
    t.ruby_opts = "-I./lib -rbundler/setup -I./spec -rcapture_warnings -rspec_helper"
    t.rspec_opts = %w[--format progress] if (ENV['FULL_BUILD'] || USING_GIT)
  end
end

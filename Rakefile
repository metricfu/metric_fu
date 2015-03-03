#!/usr/bin/env rake
using_git = File.exist?(File.expand_path('../.git/', __FILE__))
if using_git
  require 'bundler/setup'
end
require 'rake'
require 'simplecov'

Dir['./gem_tasks/*.rake'].each do |task|
  import(task)
end

require 'rspec/core/rake_task'
desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false

  t.pattern = "spec/**/_spec.rb"
  # we require spec_helper so we don't get an RSpec warning about
  # examples being defined before configuration.
  t.ruby_opts = "-I./spec -r./spec/capture_warnings -rspec_helper"
  t.rspec_opts = %w[--format progress] if (ENV['FULL_BUILD'] || !using_git)
end

require File.expand_path File.join(File.dirname(__FILE__),'lib/metric_fu')

task :default => :spec

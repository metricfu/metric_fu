#!/usr/bin/env rake
pwd = File.expand_path("..", __FILE__)
USING_GIT = File.directory?(File.join(pwd, ".git"))
if USING_GIT
  require 'bundler/setup'
end
require 'rake'
require 'simplecov'

Dir['./gem_tasks/*.rake'].each do |task|
  import(task)
end

require File.join(pwd, "lib/metric_fu")

task :default => :spec

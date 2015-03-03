# encoding: utf-8

begin
  require "yard"
rescue LoadError
else
namespace :yard do
  YARD::Rake::YardocTask.new(:doc) do |t|
    t.stats_options = ["--list-undoc"]
  end

  desc "start a gem server"
  task :server do
    sh "bundle exec yard server --gems"
  end

  desc "use Graphviz to generate dot graph"
  task :graph do
    output_file = "doc/erd.dot"
    sh "bundle exec yard graph --protected --full --dependencies > #{output_file}"
    puts "open doc/erd.dot if you have graphviz installed"
  end
end
end

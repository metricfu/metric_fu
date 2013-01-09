require 'rubygems'
require 'rspec/autorun'
require 'date'
require 'construct'

require File.expand_path File.join(File.dirname(__FILE__), '/../lib/metric_fu.rb')
include MetricFu
def compare_paths(path1,path2)
  File.join(MetricFu.root_dir,path1).should == File.join(MetricFu.root_dir,path2)
end


def compare_paths(path1, path2)
  File.join(MetricFu.root_dir, path1).should == File.join(MetricFu.root_dir, path2)
end


# TODO these directories shouldn't be written in the first place
def cleanup_test_files
  FileUtils.rm_rf(Dir["#{MetricFu.root_dir}/foo"])
  FileUtils.rm_rf(Dir["#{MetricFu.root_dir}/is set"])
rescue => e
  mf_debug "Failed cleaning up test files #{e.inspect}"
end


def resources_path
  "#{MetricFu.root_dir}/spec/resources"
end

def setup_fs
  if !MetricFu.configuration.rubinius? # fakefs doesn't seem to work on rubinius...
    FakeFS.activate!
    FakeFS::FileSystem.clone('lib')
    FakeFS::FileSystem.clone('.metrics')
    FileUtils.mkdir_p(Pathname.pwd.join(MetricFu.base_directory))
    FileUtils.mkdir_p(Pathname.pwd.join(MetricFu.output_directory))
  else
    # Have to use the file system, so let's shift the
    # output directories so that we don't interfere with
    # existing historical metric data.
    MetricFu.stub(:base_directory).and_return("tmp/metric_fu/test")
    MetricFu.stub(:output_directory).and_return("tmp/metric_fu/test/output")
    MetricFu.stub(:data_directory).and_return("tmp/metric_fu/test/_data")
  end
end

def cleanup_fs
  if !MetricFu.configuration.rubinius?
    FakeFS::FileSystem.clear
    FakeFS.deactivate!
  else
    # Not ideal, but workaround for rubinius...
    FileUtils.rm_rf("#{MetricFu.base_directory}/report.yml")
    FileUtils.rm_rf(Dir.glob("#{MetricFu.output_directory}/*.html"))
    FileUtils.rm_rf(Dir.glob("#{MetricFu.output_directory}/*.js"))
    FileUtils.rm_rf("#{MetricFu.data_directory}/#{Time.now.strftime("%Y%m%d")}.yml")
    FileUtils.rm_rf(Dir["#{MetricFu.base_directory}/customdir"])
    FileUtils.rm_rf("#{MetricFu.base_directory}/customreport.yml")
  end
end

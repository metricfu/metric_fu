def directory(name)
  MetricFu::Io::FileSystem.directory(name)
end

# TODO these directories shouldn't be written in the first place
def cleanup_test_files
  FileUtils.rm_rf(Dir["#{MetricFu.root_dir}/foo"])
  FileUtils.rm_rf(Dir["#{MetricFu.root_dir}/is set"])
rescue => e
  mf_debug "Failed cleaning up test files #{e.inspect}"
end

# fakefs doesn't seem to work reliably on non-mri rubies
def using_fake_filesystem
  return false unless MetricFu.configuration.mri?
  require 'fakefs/safe'
  true
rescue NameError, LoadError
  warn "Fake filesystem not available"
  false
end

def setup_fs
  if using_fake_filesystem
    FakeFS.activate!
    FakeFS::FileSystem.clone('lib')
    FakeFS::FileSystem.clone('.metrics')
    FileUtils.mkdir_p(Pathname.pwd.join(directory('base_directory')))
    FileUtils.mkdir_p(Pathname.pwd.join(directory('output_directory')))
  else
    # Have to use the file system, so let's shift the
    # output directories so that we don't interfere with
    # existing historical metric data.
    MetricFu::Io::FileSystem.stub(:directory).with('base_directory').and_return("tmp/metric_fu/test")
    MetricFu::Io::FileSystem.stub(:directory).with('output_directory').and_return("tmp/metric_fu/test/output")
    MetricFu::Io::FileSystem.stub(:directory).with('data_directory').and_return("tmp/metric_fu/test/_data")
    MetricFu::Io::FileSystem.stub(:directory).with('code_dirs').and_return(%w(lib))
    MetricFu::Io::FileSystem.stub(:directory).with('scratch_directory').and_return('tmp/metric_fu/test/scratch')
  end
end

def cleanup_fs
  if using_fake_filesystem
    FakeFS::FileSystem.clear
    FakeFS.deactivate!
  else
    # Not ideal, but workaround for non-mri rubies
    FileUtils.rm_rf("#{directory('base_directory')}/report.yml")
    FileUtils.rm_rf(Dir.glob("#{directory('output_directory')}/*.html"))
    FileUtils.rm_rf(Dir.glob("#{directory('output_directory')}/*.js"))
    FileUtils.rm_rf("#{directory('data_directory')}/#{Time.now.strftime("%Y%m%d")}.yml")
    FileUtils.rm_rf(Dir["#{directory('base_directory')}/customdir"])
    FileUtils.rm_rf("#{directory('base_directory')}/customreport.yml")
  end
end

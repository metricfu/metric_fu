require 'fileutils'
def directory(name)
  MetricFu::Io::FileSystem.directory(name)
end

def scratch_directory(name)
  File.join(MetricFu::Io::FileSystem.artifact_dir, 'scratch', name)
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

def artifact_test_dir
  @artficat_test_dir ||= File.join(MetricFu::APP_ROOT, 'tmp','metric_fu','test')
end

MetricFu::Io::FileSystem.artifact_dir = artifact_test_dir
MetricFu::Io::FileSystem.set_directories

def setup_fs
  # # Let's shift the output directories so that we don't interfere with
  # # existing historical metric data.
  if using_fake_filesystem
    FakeFS.activate!
    FakeFS::FileSystem.clone('lib')
    FakeFS::FileSystem.clone('.metrics')
  end
  MetricFu::Io::FileSystem.set_directories
end

def cleanup_fs
  if using_fake_filesystem
    FakeFS::FileSystem.clear
    FakeFS.deactivate!
  else
    # Not ideal, but workaround for non-mri rubies
    FileUtils.rm_rf(artifact_test_dir)
  end
end

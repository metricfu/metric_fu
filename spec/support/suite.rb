require "fileutils"
def directory(name)
  MetricFu::Io::FileSystem.directory(name)
end

def scratch_directory(name)
  File.join(MetricFu::Io::FileSystem.artifact_dir, "scratch", name)
end

def artifact_test_dir
  File.join(MetricFu::APP_ROOT, "tmp", "metric_fu", "test")
end

# Let's shift the output directories so that we don't interfere with
#   existing historical metric data.
MetricFu::Io::FileSystem.artifact_dir = artifact_test_dir
MetricFu::Io::FileSystem.set_directories

def setup_fs
  cleanup_fs
  MetricFu::Io::FileSystem.set_directories
end

def cleanup_fs
  FileUtils.rm_rf(artifact_test_dir)
end

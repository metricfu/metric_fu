shared_examples "configured" do
  def get_new_config
    ENV["CC_BUILD_ARTIFACTS"] = nil
    @config = MetricFu.configuration
    @config.reset
    MetricFu.configuration.configure_metric(:rcov) do |rcov|
      rcov.enabled = true
    end
    MetricFu.configure
    allow(MetricFu::Io::FileSystem).to receive(:create_directories) # no need to create directories for the tests
    @config
  end

  def directory(name)
    MetricFu::Io::FileSystem.directory(name)
  end

  def base_directory
    directory("base_directory")
  end

  def output_directory
    directory("output_directory")
  end

  def scratch_directory
    directory("scratch_directory")
  end

  def template_directory
    directory("template_directory")
  end

  def template_class
    MetricFu::Formatter::Templates.option("template_class")
  end

  def metric_fu_root
    directory("root_directory")
  end

  def load_metric(metric)
    load File.join(MetricFu.metrics_dir, metric, "metric.rb")
  end
end

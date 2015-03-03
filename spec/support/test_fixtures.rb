require "pathname"
class TestFixtures
  attr_reader :fixtures_path

  def initialize
    @loaded_data = {}
    @fixtures_path = Pathname(MetricFu.root_dir).join("spec", "fixtures")
  end

  def load_metric(path)
    retrieve_data(path) do |path|
      YAML.load_file(fixture_path(path))
    end
  end

  def load_file(path)
    retrieve_data(path) do |path|
      File.read(fixture_path(path))
    end
  end

  def fixture_path(path)
    fixtures_path.join(*Array(path))
  end

  private

  def retrieve_data(path)
    @loaded_data.fetch(path) do
      @loaded_data[path] = yield(path)
    end
  end
end
FIXTURE = TestFixtures.new
HOTSPOT_DATA = ->(paths) {
  FIXTURE.load_metric(["hotspots"].concat(Array(paths)))
}

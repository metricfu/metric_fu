require "spec_helper"
require "shared/configured"

describe MetricFu::Configuration, "for rcov" do
  it_behaves_like "configured" do
    it "should set rcov run_options" do
      load_metric "rcov"
      expect(
        MetricFu::Metric.get_metric(:rcov).run_options
      ).to eq(

        environment: "test",
        external: nil,
        test_files: Dir["{spec,test}/**/*_{spec,test}.rb"],
        rcov_opts: [
          "--sort coverage",
          "--no-html",
          "--text-coverage",
          "--no-color",
          "--profile",
          "--exclude-only '.*'",
          '--include-file "\Aapp,\Alib"',
          "-Ispec"
        ],
      )
    end
  end
end

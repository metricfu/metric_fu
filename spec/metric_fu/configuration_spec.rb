require "spec_helper"
require "shared/configured"

describe MetricFu::Configuration do
  it_behaves_like "configured" do
    describe "#is_cruise_control_rb?" do
      before(:each) { get_new_config }
      describe "when the CC_BUILD_ARTIFACTS env var is not nil" do
        before(:each) do
          ENV["CC_BUILD_ARTIFACTS"] = "is set"
        end

        it "should return true"  do
          expect(@config.is_cruise_control_rb?).to be_truthy
        end

        after(:each)  do
          ENV["CC_BUILD_ARTIFACTS"] = nil
          FileUtils.rm_rf(File.join(MetricFu.root_dir, "is set"))
        end
      end

      describe "when the CC_BUILD_ARTIFACTS env var is nil" do
        before(:each) { ENV["CC_BUILD_ARTIFACTS"] = nil }

        it "should return false" do
          expect(@config.is_cruise_control_rb?).to be_falsey
        end
      end
    end

    describe "#reset" do
      describe "when there is a CC_BUILD_ARTIFACTS environment variable" do
        before do
          ENV["CC_BUILD_ARTIFACTS"] = "foo"
          @config = MetricFu.configuration
          @config.reset
          MetricFu.configure
        end
        it "should return the CC_BUILD_ARTIFACTS environment variable" do
          compare_paths(base_directory, ENV["CC_BUILD_ARTIFACTS"])
        end
        after do
          ENV["CC_BUILD_ARTIFACTS"] = nil
          FileUtils.rm_rf(File.join(MetricFu.root_dir, "foo"))
        end
      end

      describe "when there is no CC_BUILD_ARTIFACTS environment variable" do
        before(:each) do
          ENV["CC_BUILD_ARTIFACTS"] = nil
          get_new_config
        end
        it "should return 'tmp/metric_fu'" do
          expect(base_directory).to eq(MetricFu.artifact_dir)
        end

        it "should set @metric_fu_root_directory to the base of the "\
        "metric_fu application" do
          app_root = File.join(File.dirname(__FILE__), "..", "..")
          app_root_absolute_path = File.expand_path(app_root)
          metric_fu_absolute_path = File.expand_path(metric_fu_root)
          expect(metric_fu_absolute_path).to eq(app_root_absolute_path)
          expect(MetricFu.root.to_s).to eq(app_root_absolute_path)
        end

        it "should set @scratch_directory to scratch relative "\
        "to @base_directory" do
          scratch_dir = MetricFu.scratch_dir
          expect(scratch_directory).to eq(scratch_dir)
        end

        it "should set @output_directory to output relative "\
        "to @base_directory" do
          output_dir = MetricFu.output_dir
          expect(output_directory).to eq(output_dir)
        end
      end
    end

    describe "#platform" do
      before(:each) { get_new_config }

      it "should return the value of the PLATFORM constant" do
        this_platform = RUBY_PLATFORM
        expect(@config.platform).to eq(this_platform)
      end
    end
  end
end

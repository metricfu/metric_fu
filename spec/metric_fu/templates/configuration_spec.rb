require "spec_helper"
require "shared/configured"

describe MetricFu::Configuration, "for templates" do
  it_behaves_like "configured" do
    describe "when there is no CC_BUILD_ARTIFACTS environment variable" do
      before(:each) do
        ENV["CC_BUILD_ARTIFACTS"] = nil
        get_new_config
      end

      it "should set @template_directory to the lib/templates relative " +         "to @metric_fu_root_directory" do
        expected_template_dir = MetricFu.root.join("lib", "templates").to_s
        expect(template_directory).to eq(expected_template_dir)
      end

      it "should set @template_class to MetricFu::Templates::MetricsTemplate by default" do
        expect(template_class).to eq(MetricFu::Templates::MetricsTemplate)
      end

      describe "when a templates configuration is given" do
        before do
          class DummyTemplate; end

          @config.templates_configuration do |config|
            config.template_class = DummyTemplate
            config.link_prefix = "http:/"
            config.syntax_highlighting = false
            config.darwin_txmt_protocol_no_thanks = false
          end
        end

        it "should set given template_class" do
          expect(template_class).to eq(DummyTemplate)
        end

        it "should set given link_prefix" do
          expect(MetricFu::Formatter::Templates.option("link_prefix")).to eq("http:/")
        end

        it "should set given darwin_txmt_protocol_no_thanks" do
          expect(MetricFu::Formatter::Templates.option("darwin_txmt_protocol_no_thanks")).to be_falsey
        end

        it "should set given syntax_highlighting" do
          expect(MetricFu::Formatter::Templates.option("syntax_highlighting")).to be_falsey
        end
      end
    end
  end
end

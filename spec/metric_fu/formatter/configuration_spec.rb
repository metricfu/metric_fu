require "spec_helper"
require "shared/configured"

describe MetricFu::Configuration, "for formatters" do
  it_behaves_like "configured" do
    describe "#configure_formatter" do
      before(:each) { get_new_config }

      context "given a built-in formatter" do
        before do
          @config.configure_formatter("html")
        end

        it "adds to the list of formatters" do
          expect(@config.formatters.first).to be_an_instance_of(MetricFu::Formatter::HTML)
        end
      end

      context "given a custom formatter by class name" do
        before do
          stub_const("MyCustomFormatter", Class.new { def initialize(*); end })
          @config.configure_formatter("MyCustomFormatter")
        end

        it "adds to the list of formatters" do
          expect(@config.formatters.first).to be_an_instance_of(MyCustomFormatter)
        end
      end

      context "given multiple formatters" do
        before do
          stub_const("MyCustomFormatter", Class.new { def initialize(*); end })
          @config.configure_formatter("html")
          @config.configure_formatter("yaml")
          @config.configure_formatter("MyCustomFormatter")
        end

        it "adds each to the list of formatters" do
          expect(@config.formatters.count).to eq(3)
        end
      end
    end
  end
end

require "spec_helper"

describe MetricFu::Formatter do
  describe "formatter class loading" do
    context "given a built-in formatter (string)" do
      subject { MetricFu::Formatter.class_for("html") }

      it "returns the formatter class" do
        expect(subject).to eq(MetricFu::Formatter::HTML)
      end
    end

    context "given a built-in formatter (symbol)" do
      subject { MetricFu::Formatter.class_for(:yaml) }

      it "returns the formatter class" do
        expect(subject).to eq(MetricFu::Formatter::YAML)
      end
    end

    context "given an unknown built-in formatter" do
      subject { MetricFu::Formatter.class_for(:unknown) }

      it "raises an error" do
        expect { subject }.to raise_error(NameError)
      end
    end

    context "given a custom formatter that exists" do
      subject { MetricFu::Formatter.class_for("MyCustomFormatter") }

      before do
        stub_const("MyCustomFormatter", Class.new { def initialize(*); end })
      end

      it "returns the formatter class" do
        expect(subject).to eq(MyCustomFormatter)
      end
    end

    context "given a custom formatter that doesnt exist" do
      subject { MetricFu::Formatter.class_for("MyNonExistentCustomFormatter") }

      it "raises an error" do
        expect { subject }.to raise_error(NameError)
      end
    end
  end
end

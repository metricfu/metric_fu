require "spec_helper"
MetricFu.lib_require { "templates/report" }

describe MetricFu::Templates::Report do
  # TODO: This test only shows how the code works and that it doesn't blow up.
  # Perhaps it should test something more specific?
  it "Reads in a source file, and produces an annotated HTML report" do
    lines = { "2" => [{ type: :reek, description: "Bad Param Names" }] }
    source_file = File.join(MetricFu.root_dir, "spec", "dummy", "lib", "bad_encoding.rb")
    report = MetricFu::Templates::Report.new(source_file, lines)
    expect {
      rendered_report = report.render
    }.not_to raise_error
  end
end

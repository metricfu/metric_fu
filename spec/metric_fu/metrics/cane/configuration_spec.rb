require "spec_helper"
require "shared/configured"

describe MetricFu::Configuration, "for cane" do
  it_behaves_like "configured" do
    if MetricFu.configuration.mri?
      it "should set @cane to " +
        ':dirs_to_cane => @code_dirs, :abc_max => 15, :line_length => 80, :no_doc => "n", :no_readme => "y"' do
        load_metric "cane"
        expect(MetricFu::Metric.get_metric(:cane).run_options).to eq(

            dirs_to_cane: directory("code_dirs"),
            filetypes: ["rb"],
            abc_max: 15,
            line_length: 80,
            no_doc: "n",
            no_readme: "n"
            )
      end
    end
  end # end it_behaves
end

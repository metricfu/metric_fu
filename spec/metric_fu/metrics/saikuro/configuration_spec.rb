require "spec_helper"
require "shared/configured"

describe MetricFu::Configuration, "for saikuro" do
  it_behaves_like "configured" do
    it "should set @saikuro to { :output_directory => @scratch_directory + '/saikuro',
                                 :input_directory => @code_dirs,
                                 :cyclo => '',
                                 :filter_cyclo => '0',
                                 :warn_cyclo => '5',
                                 :error_cyclo => '7',
                                 :formater => 'text' }" do
      load_metric "saikuro"
      expect(MetricFu::Metric.get_metric(:saikuro).run_options).to eq(
               output_directory: "#{scratch_directory}/saikuro",
               input_directory: ["lib"],
               cyclo: "",
               filter_cyclo: "0",
               warn_cyclo: "5",
               error_cyclo: "7",
               formater: "text"
                    )
    end
  end
end

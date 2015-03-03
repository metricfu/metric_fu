require "spec_helper"
MetricFu.metrics_require { "flog/generator" }

describe MetricFu::FlogGenerator do
  break if metric_not_activated?(:flog)

  before :each do
    allow(File).to receive(:directory?).and_return(true)
    options = MetricFu::Metric.get_metric(:flog).run_options
    @flog = MetricFu::FlogGenerator.new(options)
  end

  describe "emit method" do
    it "should look for files and flog them" do
      expect(FlogCLI).to receive(:parse_options).with(["--all", "--continue"]).and_return("options")
      expect(FlogCLI).to receive(:new).with("options").and_return(flogger = double("flogger"))
      expect(flogger).to receive(:flog).with("lib")
      @flog.emit
    end
  end

  describe "analyze method" do
    it "should harvest the flog information and put it into method_containers" do
      first_full_method_name = "ClassName#first_method_name"
      second_full_method_name = "ClassName#second_method_name"

      flogger = double("flogger", method_locations: { first_full_method_name => "/file/location.rb:11",
                                                      second_full_method_name => "/file/location.rb:22" },
                                  totals: { first_full_method_name => 11.11,
                                            second_full_method_name => 22.22 })
      expect(flogger).to receive(:calculate)
      expect(flogger).to receive(:each_by_score).and_yield(
        first_full_method_name, 11.11, branch: 11.1, puts: 1.1
      ).and_yield(
        second_full_method_name, 22.22, branch: 22.2, puts: 2.2
      )
      @flog.instance_variable_set(:@flogger, flogger)
      @flog.analyze
      method_containers = @flog.instance_variable_get(:@method_containers)
      expect(method_containers.size).to eq(1)

      expected = { methods: { "ClassName#first_method_name" => { path: "/file/location.rb:11",
                                                                 score: 11.11,
                                                                 operators: { branch: 11.1,
                                                                              puts: 1.1 } },
                              "ClassName#second_method_name" => { path: "/file/location.rb:22",
                                                                  score: 22.22,
                                                                  operators: { branch: 22.2,
                                                                               puts: 2.2 } } },
                   path: "/file/location.rb",
                   average_score: ((11.11 + 22.22) / 2.0),
                   total_score: 33.33,
                   highest_score: 22.22,
                   name: "ClassName" }

      expect(method_containers["ClassName"].to_h).to eq(expected)
    end
  end

  describe "to_h method" do
    it "should make-a nice hash" do
      flogger = double("flogger", total_score: 111.1, average: 7.3)
      @flog.instance_variable_set(:@flogger, flogger)
      method_containers = { ignore_me_1: double("container_1", highest_score: 11.1, to_h: "container_1"),
                            ignore_me_2: double("container_2", highest_score: 33.3, to_h: "container_2"),
                            ignore_me_3: double("container_3", highest_score: 22.2, to_h: "container_3") }
      @flog.instance_variable_set(:@method_containers, method_containers)

      expected = { flog: { total: 111.1,
                           average: 7.3,
                           method_containers: ["container_2", "container_3", "container_1"] } }

      expect(@flog.to_h).to eq(expected)
    end
  end
end

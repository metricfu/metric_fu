require "spec_helper"
MetricFu.metrics_require { "flay/generator" }

describe MetricFu::FlayGenerator do
  describe "emit method" do
    it "should look at the dirs" do
      options = { dirs_to_flay: ["app", "lib"] }
      allow(File).to receive(:directory?).and_return(true)
      @flay = MetricFu::FlayGenerator.new(options)

      expect(@flay).to receive(:run!).with(" app lib")
      output = @flay.emit
    end

    it "should limit flay scores by the minimum_score" do
      options = { dirs_to_flay: [], minimum_score: 99 }
      allow(File).to receive(:directory?).and_return(true)
      @flay = MetricFu::FlayGenerator.new(options)

      expect(@flay).to receive(:run!).with("--mass 99  ")
      output = @flay.emit
    end
  end

  describe "analyze method" do
    before :each do
      lines = <<-HERE
Total score (lower is better) = 246


1) IDENTICAL code found in :or (mass*2 = 68)
  app/controllers/link_targets_controller.rb:57
  app/controllers/primary_sites_controller.rb:138

2) Similar code found in :if (mass = 64)
  app/controllers/primary_sites_controller.rb:75
  app/controllers/primary_sites_controller.rb:76
  app/controllers/primary_sites_controller.rb:88
  app/controllers/primary_sites_controller.rb:89
      HERE
      MetricFu::Configuration.run {}
      allow(File).to receive(:directory?).and_return(true)
      @flay = MetricFu::FlayGenerator.new("base_dir")
      @flay.instance_variable_set(:@output, lines)
    end

    it "should analyze and return matches" do
      expect(@flay.analyze).to eq([["Total score (lower is better) = 246"],
                                   ["\n1) IDENTICAL code found in :or (mass*2 = 68)",
                                    "app/controllers/link_targets_controller.rb:57",
                                    "app/controllers/primary_sites_controller.rb:138"],
                                   ["2) Similar code found in :if (mass = 64)",
                                    "app/controllers/primary_sites_controller.rb:75",
                                    "app/controllers/primary_sites_controller.rb:76",
                                    "app/controllers/primary_sites_controller.rb:88",
                                    "app/controllers/primary_sites_controller.rb:89"]])
    end
  end

  describe "to_h method" do
    before :each do
      lines = [["Total score (lower is better) = 284"],
               ["\n1) IDENTICAL code found in :or (mass*2 = 68)",
                "app/controllers/link_targets_controller.rb:57",
                "app/controllers/primary_sites_controller.rb:138"],
               ["2) Similar code found in :if (mass = 64)",
                "app/controllers/primary_sites_controller.rb:75",
                "app/controllers/primary_sites_controller.rb:76",
                "app/controllers/primary_sites_controller.rb:88",
                "app/controllers/primary_sites_controller.rb:89"],
               ["3) Similar code found in :defn (mass = 40)",
                "app/controllers/link_targets_controller.rb:40",
                "app/controllers/primary_sites_controller.rb:98"],
               ["4) Similar code found in :defn (mass = 38)",
                "app/controllers/link_targets_controller.rb:13",
                "app/controllers/primary_sites_controller.rb:50"],
               ["5) Similar code found in :defn (mass = 38)",
                "app/models/primary_site.rb:104",
                "app/models/primary_site.rb:109"],
               ["6) Similar code found in :call (mass = 36)",
                "app/controllers/bookmarklet_integration_controller.rb:6",
                "app/controllers/bookmarklet_integration_controller.rb:17"]]

      MetricFu::Configuration.run {}
      allow(File).to receive(:directory?).and_return(true)
      flay = MetricFu::FlayGenerator.new("base_dir")
      flay.instance_variable_set(:@matches, lines)
      @results = flay.to_h
    end

    it "should find the total_score" do
      expect(@results[:flay][:total_score]).to eq("284")
    end

    it "should have 6 matches" do
      expect(@results[:flay][:matches].size).to eq(6)
    end

    it "should capture info for match" do
      expect(@results[:flay][:matches].first[:reason]).to match(/IDENTICAL/)
      expect(@results[:flay][:matches].first[:matches].first[:name]).to match(/link_targets_controller/)
      expect(@results[:flay][:matches].first[:matches].first[:line]).to eq("57")
    end
  end
end

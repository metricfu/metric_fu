require "spec_helper"
MetricFu.metrics_require { "saikuro/generator" }

describe MetricFu::SaikuroGenerator do
  STUB_TEST_DATA = lambda do |generator|
    # set test data dir; ensure it doesn't get cleared
    def generator.metric_directory
      FIXTURE.fixtures_path.join("saikuro").to_s
    end
    def generator.clear_scratch_files!
      # no-op
    end
  end
  describe "to_h method" do
    before do
      options = {}
      saikuro = MetricFu::SaikuroGenerator.new(options)
      STUB_TEST_DATA[saikuro]

      saikuro.analyze
      @output = saikuro.to_h
    end

    it "should find the filename of a file" do
      expect(@output[:saikuro][:files].first[:filename]).to eq("app/controllers/users_controller.rb")
    end

    it "should find the name of the classes" do
      expect(@output[:saikuro][:classes].first[:name]).to eq("UsersController")
      expect(@output[:saikuro][:classes][1][:name]).to eq("SessionsController")
    end

    it "should put the most complex method first" do
      expect(@output[:saikuro][:methods].first[:name]).to eq("UsersController#create")
      expect(@output[:saikuro][:methods].first[:complexity]).to eq(4)
    end

    it "should find the complexity of a method" do
      expect(@output[:saikuro][:methods].first[:complexity]).to eq(4)
    end

    it "should find the lines of a method" do
      expect(@output[:saikuro][:methods].first[:lines]).to eq(15)
    end
  end

  describe "per_file_info method" do
    before :all do
      options = {}
      @saikuro = MetricFu::SaikuroGenerator.new(options)
      STUB_TEST_DATA[@saikuro]
      @saikuro.analyze
      @output = @saikuro.to_h
    end

    it "doesn't try to get information if the file does not exist" do
      expect(@saikuro).to receive(:file_not_exists?).at_least(:once).and_return(true)
      @saikuro.per_file_info("ignore_me")
    end
  end

  describe MetricFu::SaikuroScratchFile do
    describe "getting elements from a Saikuro result file" do
      it "should parse nested START/END sections" do
        path = FIXTURE.fixtures_path.join("saikuro_sfiles", "thing.rb_cyclo.html").to_s
        sfile = MetricFu::SaikuroScratchFile.new path
        expect(sfile.elements.map(&:complexity).sort).to eql(["0", "0", "2"])
      end
    end
  end
end

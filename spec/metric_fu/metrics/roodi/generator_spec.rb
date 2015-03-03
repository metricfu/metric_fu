require "spec_helper"
MetricFu.metrics_require { "roodi/generator" }

describe MetricFu::RoodiGenerator do
  describe "emit" do
    it "should add config options when present" do
      options = { roodi_config: "lib/config/roodi_config.yml", dirs_to_roodi: [] }
      roodi = MetricFu::RoodiGenerator.new(options)
      expect(roodi).to receive(:run!).with(/-config=lib\/config\/roodi_config\.yml/).and_return("")
      roodi.emit
    end

    it "should NOT add config options when NOT present" do
      options = { dirs_to_roodi: [] }
      roodi = MetricFu::RoodiGenerator.new(options)
      allow(roodi).to receive(:run!)
      expect(roodi).to receive(:run!).with(/-config/).never
      roodi.emit
    end
  end

  describe "analyze" do
    context "when it has multiple failures" do
      before :each do
        lines = <<-HERE

Running Roodi checks
./app/models/some_model.rb:14 - Found = in conditional.  It should probably be an ==
lib/some_file.rb:53 - Rescue block should not be empty.

Checked 65 files
        HERE

        roodi = MetricFu::RoodiGenerator.new
        roodi.instance_variable_set(:@output, lines)
        @matches = roodi.analyze
      end

      it "should find all problems" do
        problem_count = @matches[:problems].size
        expect(problem_count).to eq(2)
      end

      it "should find the file of the problem" do
        problem = @matches[:problems].first
        expect(problem[:file]).to eq("./app/models/some_model.rb")
      end

      it "should find the line of the problem" do
        problem = @matches[:problems].first
        expect(problem[:line]).to eq("14")
      end

      it "should find the description of the problem" do
        problem = @matches[:problems].first
        expect(problem[:problem]).to eq("Found = in conditional.  It should probably be an ==")
      end
    end
  end

  context "when it has no failures" do
    before :each do
      lines = <<-HERE

Running Roodi checks

Checked 42 files
Found 0 errors.

      HERE

      roodi = MetricFu::RoodiGenerator.new
      roodi.instance_variable_set(:@output, lines)
      @matches = roodi.analyze
    end

    it "should have no problems" do
      problem_count = @matches[:problems].size
      expect(problem_count).to eq(0)
    end
  end
end

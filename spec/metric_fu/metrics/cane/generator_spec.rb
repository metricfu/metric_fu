require "spec_helper"
MetricFu.metrics_require { "cane/generator" }

describe CaneGenerator do
  describe "emit method" do
    it "should execute cane command" do
      options = {}
      @cane = MetricFu::CaneGenerator.new(options)
      expect(@cane).to receive(:run!).with("")
      output = @cane.emit
    end

    it "should use abc max option" do
      options = { abc_max: 20 }
      @cane = MetricFu::CaneGenerator.new(options)
      expect(@cane).to receive(:run!).with(" --abc-max 20")
      output = @cane.emit
    end

    it "should use style max line length option" do
      options = { line_length: 100 }
      @cane = MetricFu::CaneGenerator.new(options)
      expect(@cane).to receive(:run!).with(" --style-measure 100")
      output = @cane.emit
    end

    it "should use no-doc if specified" do
      options = { no_doc: "y" }
      @cane = MetricFu::CaneGenerator.new(options)
      expect(@cane).to receive(:run!).with(" --no-doc")
      output = @cane.emit
    end

    it "should include doc violations if no_doc != 'y'" do
      options = { no_doc: "n" }
      @cane = MetricFu::CaneGenerator.new(options)
      expect(@cane).to receive(:run!).with("")
      output = @cane.emit
    end

    it "should use no-readme if specified" do
      options = { no_readme: "y" }
      @cane = MetricFu::CaneGenerator.new(options)
      expect(@cane).to receive(:run!).with(" --no-readme")
      output = @cane.emit
    end

    it "should include README violations if no_readme != 'y'" do
      options = { no_readme: "n" }
      @cane = MetricFu::CaneGenerator.new(options)
      expect(@cane).to receive(:run!).with("")
      output = @cane.emit
    end
  end

  describe "parse cane empty output" do
    before :each do
      # MetricFu::Configuration.run {}
      allow(File).to receive(:directory?).and_return(true)
      options = {}
      @cane = MetricFu::CaneGenerator.new(options)
      @cane.instance_variable_set(:@output, "")
    end

    describe "analyze method" do
      it "should find total violations" do
        @cane.analyze
        expect(@cane.total_violations).to eq(0)
      end
    end
  end

  describe "parse cane output" do
    before :each do
      lines = sample_cane_output
      MetricFu::Configuration.run {}
      allow(File).to receive(:directory?).and_return(true)
      @cane = MetricFu::CaneGenerator.new("base_dir")
      @cane.instance_variable_set(:@output, lines)
    end

    describe "analyze method" do
      it "should find total violations" do
        @cane.analyze
        expect(@cane.total_violations).to eq(6)
      end

      it "should extract abc complexity violations" do
        @cane.analyze
        expect(@cane.violations[:abc_complexity]).to eq([
          { file: "lib/abc/foo.rb", method: "Abc::Foo#method", complexity: "11" },
          { file: "lib/abc/bar.rb", method: "Abc::Bar#method", complexity: "22" }
        ])
      end

      it "should extract line style violations" do
        @cane.analyze
        expect(@cane.violations[:line_style]).to eq([
          { line: "lib/line/foo.rb:1", description: "Line is >80 characters (135)" },
          { line: "lib/line/bar.rb:2", description: "Line contains trailing whitespace" }
        ])
      end

      it "should extract comment violations" do
        @cane.analyze
        expect(@cane.violations[:comment]).to eq([
          { line: "lib/comments/foo.rb:1", class_name: "Foo" },
          { line: "lib/comments/bar.rb:2", class_name: "Bar" }
        ])
      end

      it "should extract no readme violations if present" do
        @cane.analyze
        expect(@cane.violations[:documentation]).to eq([
          { description: "No README found" },
        ])
      end

      it "should extract unknown violations in others category" do
        @cane.analyze
        expect(@cane.violations[:others]).to eq([
          { description: "Misc issue 1" },
          { description: "Misc issue 2" }
        ])
      end
    end

    describe "to_h method" do
      it "should have total violations" do
        @cane.analyze
        expect(@cane.to_h[:cane][:total_violations]).to eq(6)
      end

      it "should have violations by category" do
        @cane.analyze
        expect(@cane.to_h[:cane][:violations][:abc_complexity]).to eq([
          { file: "lib/abc/foo.rb", method: "Abc::Foo#method", complexity: "11" },
          { file: "lib/abc/bar.rb", method: "Abc::Bar#method", complexity: "22" }
        ])
        expect(@cane.to_h[:cane][:violations][:line_style]).to eq([
          { line: "lib/line/foo.rb:1", description: "Line is >80 characters (135)" },
          { line: "lib/line/bar.rb:2", description: "Line contains trailing whitespace" }
        ])
        expect(@cane.to_h[:cane][:violations][:comment]).to eq([
          { line: "lib/comments/foo.rb:1", class_name: "Foo" },
          { line: "lib/comments/bar.rb:2", class_name: "Bar" }
        ])
      end
    end
  end

  def sample_cane_output
    <<-OUTPUT
Methods exceeded maximum allowed ABC complexity (33):

  lib/abc/foo.rb       Abc::Foo#method 11
  lib/abc/bar.rb       Abc::Bar#method 22

Lines violated style requirements (340):

  lib/line/foo.rb:1       Line is >80 characters (135)
  lib/line/bar.rb:2       Line contains trailing whitespace

Missing documentation (1):

  No README found

Class definitions require explanatory comments on preceding line (2):

  lib/comments/foo.rb:1       Foo
  lib/comments/bar.rb:2       Bar

Unknown violation (1):

  Misc issue 1

Another Unknown violation (1):

  Misc issue 2

Total Violations: 6
    OUTPUT
  end
end

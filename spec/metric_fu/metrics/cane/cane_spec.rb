require 'spec_helper'

describe Cane do
  describe "emit method" do
    def configure_cane_with(options={})
      MetricFu::Configuration.run {|config|
        config.add_metric(:cane)
        config.configure_metric(:cane, options)
      }
    end

    it "should execute cane command" do
      configure_cane_with({})
      @cane = MetricFu::Cane.new('base_dir')
      @cane.should_receive(:`).with("mf-cane")
      output = @cane.emit
    end

    it "should use abc max option" do
      configure_cane_with({abc_max: 20})
      @cane = MetricFu::Cane.new('base_dir')
      @cane.should_receive(:`).with("mf-cane --abc-max 20")
      output = @cane.emit
    end

    it "should use style max line length option" do
      configure_cane_with({line_length: 100})
      @cane = MetricFu::Cane.new('base_dir')
      @cane.should_receive(:`).with("mf-cane --style-measure 100")
      output = @cane.emit
    end

    it "should use no-doc if specified" do
      configure_cane_with({no_doc: 'y'})
      @cane = MetricFu::Cane.new('base_dir')
      @cane.should_receive(:`).with("mf-cane --no-doc")
      output = @cane.emit
    end

    it "should include doc violations if no_doc != 'y'" do
      configure_cane_with({no_doc: 'n'})
      @cane = MetricFu::Cane.new('base_dir')
      @cane.should_receive(:`).with("mf-cane")
      output = @cane.emit
    end

    it "should use no-readme if specified" do
      configure_cane_with({no_readme: 'y'})
      @cane = MetricFu::Cane.new('base_dir')
      @cane.should_receive(:`).with("mf-cane --no-readme")
      output = @cane.emit
    end

    it "should include README violations if no_readme != 'y'" do
      configure_cane_with({no_readme: 'n'})
      @cane = MetricFu::Cane.new('base_dir')
      @cane.should_receive(:`).with("mf-cane")
      output = @cane.emit
    end
  end

  describe "parse cane empty output" do
    before :each do
      MetricFu::Configuration.run {}
      File.stub!(:directory?).and_return(true)
      @cane = MetricFu::Cane.new('base_dir')
      @cane.instance_variable_set(:@output, '')
    end

    describe "analyze method" do

      it "should find total violations" do
        @cane.analyze
        @cane.total_violations.should == 0
      end
    end
  end

  describe "parse cane output" do
    before :each do
      lines = sample_cane_output
      MetricFu::Configuration.run {}
      File.stub!(:directory?).and_return(true)
      @cane = MetricFu::Cane.new('base_dir')
      @cane.instance_variable_set(:@output, lines)
    end

    describe "analyze method" do

      it "should find total violations" do
        @cane.analyze
        @cane.total_violations.should == 6
      end

      it "should extract abc complexity violations" do
        @cane.analyze
        @cane.violations[:abc_complexity].should == [
          {file: 'lib/abc/foo.rb', method: 'Abc::Foo#method', complexity: '11'},
          {file: 'lib/abc/bar.rb', method: 'Abc::Bar#method', complexity: '22'}
        ]
      end

      it "should extract line style violations" do
        @cane.analyze
        @cane.violations[:line_style].should == [
          {line: 'lib/line/foo.rb:1', description: 'Line is >80 characters (135)'},
          {line: 'lib/line/bar.rb:2', description: 'Line contains trailing whitespace'}
        ]
      end

      it "should extract comment violations" do
        @cane.analyze
        @cane.violations[:comment].should == [
          {line: 'lib/comments/foo.rb:1', class_name: 'Foo'},
          {line: 'lib/comments/bar.rb:2', class_name: 'Bar'}
        ]
      end

      it "should extract no readme violations if present" do
        @cane.analyze
        @cane.violations[:documentation].should == [
          {description: 'No README found'},
        ]
      end

      it "should extract unknown violations in others category" do
        @cane.analyze
        @cane.violations[:others].should == [
          {description: 'Misc issue 1'},
          {description: 'Misc issue 2'}
        ]
      end
    end

    describe "to_h method" do
      it "should have total violations" do
        @cane.analyze
        @cane.to_h[:cane][:total_violations].should == 6
      end

      it  "should have violations by category" do
        @cane.analyze
        @cane.to_h[:cane][:violations][:abc_complexity].should == [
          {file: 'lib/abc/foo.rb', method: 'Abc::Foo#method', complexity: '11'},
          {file: 'lib/abc/bar.rb', method: 'Abc::Bar#method', complexity: '22'}
        ]
        @cane.to_h[:cane][:violations][:line_style].should == [
          {line: 'lib/line/foo.rb:1', description: 'Line is >80 characters (135)'},
          {line: 'lib/line/bar.rb:2', description: 'Line contains trailing whitespace'}
        ]
        @cane.to_h[:cane][:violations][:comment].should == [
          {line: 'lib/comments/foo.rb:1', class_name: 'Foo'},
          {line: 'lib/comments/bar.rb:2', class_name: 'Bar'}
        ]
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

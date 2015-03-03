require "spec_helper"
MetricFu.data_structures_require { "line_numbers" }

describe MetricFu::LineNumbers do
  FIXTURE_DATA = ->(paths) {
    FIXTURE.load_file(["line_numbers"].concat(Array(paths)))
  }
  describe "in_method?" do
    it "should know if a line is NOT in a method" do
      ln = MetricFu::LineNumbers.new(FIXTURE_DATA["foo.rb"])
      expect(ln.in_method?(2)).to eq(false)
    end

    it "should know if a line is in an instance method" do
      ln = MetricFu::LineNumbers.new(FIXTURE_DATA["foo.rb"])
      expect(ln.in_method?(8)).to eq(true)
    end

    it "should know if a line is in an class method" do
      ln = MetricFu::LineNumbers.new(FIXTURE_DATA["foo.rb"])
      expect(ln.in_method?(3)).to eq(true)
    end
  end

  describe "method_at_line" do
    it "should know the name of an instance method at a particular line" do
      ln = MetricFu::LineNumbers.new(FIXTURE_DATA["foo.rb"])
      expect(ln.method_at_line(8)).to eq("Foo#what")
    end

    it "should know the name of a class method at a particular line" do
      ln = MetricFu::LineNumbers.new(FIXTURE_DATA["foo.rb"])
      expect(ln.method_at_line(3)).to eq("Foo::awesome")
    end

    it "should know the name of a private method at a particular line" do
      ln = MetricFu::LineNumbers.new(FIXTURE_DATA["foo.rb"])
      expect(ln.method_at_line(28)).to eq("Foo#whoop")
    end

    it "should know the name of a class method defined in a 'class << self block at a particular line" do
      ln = MetricFu::LineNumbers.new(FIXTURE_DATA["foo.rb"])
      expect(ln.method_at_line(22)).to eq("Foo::neat")
    end

    it "should know the name of an instance method at a particular line in a file with two classes" do
      ln = MetricFu::LineNumbers.new(FIXTURE_DATA["two_classes.rb"])
      expect(ln.method_at_line(3)).to eq("Foo#stuff")
      expect(ln.method_at_line(9)).to eq("Bar#stuff")
    end

    it "should work with modules" do
      ln = MetricFu::LineNumbers.new(FIXTURE_DATA["module.rb"])
      expect(ln.method_at_line(4)).to eq("KickAss#get_beat_up?")
    end

    it "should work with module surrounding class" do
      ln = MetricFu::LineNumbers.new(FIXTURE_DATA["module_surrounds_class.rb"])
      expect(ln.method_at_line(5)).to eq("StuffModule::ThingClass#do_it")
      # ln.method_at_line(12).should == "StuffModule#blah" #why no work?
    end
  end
end

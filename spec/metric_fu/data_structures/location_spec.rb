require "spec_helper"
MetricFu.data_structures_require { "location" }

describe MetricFu::Location do
  context "with non-standard Reek method names" do
    # reek reports the method with :: not # on modules like
    # module ApplicationHelper \n def signed_in?, convert it so it records correctly
    # class_or_method_name = class_or_method_name.gsub(/\:\:/,"#") if method_bug_conversion

    before do
      @location = Location.for("ApplicationHelper::section_link")
    end

    it "has method name" do
      expect(@location.method_name).to eq("ApplicationHelper#section_link")
    end

    it "has nil file path" do
      expect(@location.file_path).to eq(nil)
    end

    it "has class name" do
      expect(@location.class_name).to eq("ApplicationHelper")
    end
  end

  context "using new" do
    before do
      @location = Location.new("lib/foo.rb", "Foo", "Foo#some_method")
    end

    it "should return fully qualified method" do
      expect(@location.method_name).to eq("Foo#some_method")
    end
  end

  context "using .for with class" do
    before do
      @location = Location.for("Module::Foo")
    end

    it "has nil method_name" do
      expect(@location.method_name).to be nil
    end

    it "has nil file_path" do
      expect(@location.file_path).to be nil
    end

    it "has class_name" do
      expect(@location.class_name).to eq("Foo")
    end
  end

  context "using .for with method" do
    before do
      @location = Location.for("Module::Foo#some_method")
    end

    it "strips module from class name" do
      expect(@location.class_name).to eq("Foo")
    end

    it "strips module from method name" do
      expect(@location.method_name).to eq("Foo#some_method")
    end

    it "has nil file_path" do
      expect(@location.file_path).to be nil
    end
  end

  context "with class method" do
    it "provides non-qualified name" do
      location = Location.for("Foo.some_class_method")
      expect(location.simple_method_name).to eq(".some_class_method")
    end
  end

  context "with instance method" do
    it "provides non-qualified name" do
      location = Location.for("Foo#some_class_method")
      expect(location.simple_method_name).to eq("#some_class_method")
    end
  end
  context "testing equality" do
    before :each do
      @location1 = MetricFu::Location.get("/some/path", "some_class", "some_method")

      # ensure that we get a new object
      @location2 = MetricFu::Location.new("/some/path", "some_class", "some_method")
    end
    it "should match two locations with the same paths as equal" do
      hsh1 = {}
      hsh1[@location1] = 1

      hsh2 = {}
      hsh2[@location2] = 1

      expect(hsh1).to eq(hsh2)
      expect(hsh1.eql?(hsh2)).to be_truthy

      expect(@location1.eql?(@location2)).to be_truthy
    end

    it "should produce the same hash value given the same paths" do
      expect(@location1.hash).to eq(@location2.hash)
    end
  end
end

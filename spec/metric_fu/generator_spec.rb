require "spec_helper"

describe MetricFu::Generator do
  include TestConstruct::Helpers

  class ConcreteClass < MetricFu::Generator
    def self.metric
      :concrete
    end

    def emit
    end

    def analyze
    end

    def to_h
    end
  end

  before(:each) do
    ENV["CC_BUILD_ARTIFACTS"] = nil
    MetricFu.configuration.reset
    MetricFu.configure
    @concrete_class = ConcreteClass.new
  end

  describe "ConcreteClass#metric_directory" do
    it "should be '{artifact_dir}/scratch/concreteclass'" do
      concrete_metric = double("concrete_metric")
      expect(MetricFu::Metric).to receive(:get_metric).with(:concrete).and_return(concrete_metric)
      expect(concrete_metric).to receive(:run_options).and_return({})
      compare_paths(ConcreteClass.metric_directory, scratch_directory("concrete"))
    end
  end

  describe "#metric_directory" do
    it "should return the results of ConcreteClass#metric_directory" do
      allow(ConcreteClass).to receive(:metric_directory).and_return("foo")
      expect(@concrete_class.metric_directory).to eq("foo")
    end
  end

  describe "#generate_result" do
    it "should  raise an error when calling #emit" do
      @abstract_class = MetricFu::Generator.new
      expect { @abstract_class.generate_result }.to raise_error
    end

    it "should call #analyze" do
      @abstract_class = MetricFu::Generator.new
      expect { @abstract_class.generate_result }.to raise_error
    end

    it "should call #to_h" do
      @abstract_class = MetricFu::Generator.new
      expect { @abstract_class.generate_result }.to raise_error
    end
  end

  describe "#generate_result (in a concrete class)" do
    %w[emit analyze].each do |meth|
      it "should call ##{meth}" do
        expect(@concrete_class).to receive("#{meth}")
        @concrete_class.generate_result
      end
    end

    it "should call #to_h" do
      expect(@concrete_class).to receive(:to_h)
      @concrete_class.generate_result
    end
  end

  describe "path filter" do
    context "given a list of paths" do
      before do
        @paths = %w(lib/fake/fake.rb
                    lib/this/dan_file.rb
                    lib/this/ben_file.rb
                    lib/this/avdi_file.rb
                    basic.rb
                    lib/bad/one.rb
                    lib/bad/two.rb
                    lib/bad/three.rb
                    lib/worse/four.rb)
        @container = create_construct
        @paths.each do |path|
          @container.file(path)
        end
        @old_dir = MetricFu.run_dir
        Dir.chdir(@container)
      end

      after do
        Dir.chdir(@old_dir)
        @container.destroy!
      end

      it "should return entire pathlist given no exclude pattens" do
        files = @concrete_class.remove_excluded_files(@paths)
        expect(files).to eq(@paths)
      end

      it "should filter filename at root level" do
        files = @concrete_class.remove_excluded_files(@paths, ["basic.rb"])
        expect(files).not_to include("basic.rb")
      end

      it "should remove files that are two levels deep" do
        files = @concrete_class.remove_excluded_files(@paths, ["**/fake.rb"])
        expect(files).not_to include("lib/fake/fake.rb")
      end

      it "should remove files from an excluded directory" do
        files = @concrete_class.remove_excluded_files(@paths, ["lib/bad/**"])
        expect(files).not_to include("lib/bad/one.rb")
        expect(files).not_to include("lib/bad/two.rb")
        expect(files).not_to include("lib/bad/three.rb")
      end

      it "should support shell alternation globs" do
        files = @concrete_class.remove_excluded_files(@paths, ["lib/this/{ben,dan}_file.rb"])
        expect(files).not_to include("lib/this/dan_file.rb")
        expect(files).not_to include("lib/this/ben_file.rb")
        expect(files).to include("lib/this/avdi_file.rb")
      end
    end
  end
end

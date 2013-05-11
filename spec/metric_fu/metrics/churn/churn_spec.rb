require "spec_helper"

describe Churn do

  let(:churn_yaml) { "--- \n:churn: \n  :changed_files: \n  - spec/graphs/flog_grapher_spec.rb\n  - spec/base/graph_spec.rb\n  - lib/templates/awesome/layout.html.erb\n  - lib/graphs/rcov_grapher.rb\n  - lib/base/base_template.rb\n  - spec/graphs/grapher_spec.rb\n  - lib/templates/awesome/flog.html.erb\n  - lib/templates/awesome/flay.html.erb\n  - lib/graphs/roodi_grapher.rb\n  - lib/graphs/reek_grapher.rb\n  - HISTORY\n  - spec/graphs/roodi_grapher_spec.rb\n  - lib/generators/rcov.rb\n  - spec/graphs/engines/gchart_spec.rb\n  - spec/graphs/rcov_grapher_spec.rb\n  - lib/templates/javascripts/excanvas.js\n  - lib/templates/javascripts/bluff-min.js\n  - spec/graphs/reek_grapher_spec.rb\n" }

  let(:config_setup) {
    ENV['CC_BUILD_ARTIFACTS'] = nil
    MetricFu.configure.reset
    File.stub!(:directory?).and_return(true)
  }

  describe "new method" do
    before :each do
      config_setup
    end

    it "initializes with yaml option" do
      churn = MetricFu::Churn.new
      churn.send(:build_churn_options).should == "--yaml"
    end

    it "initializes with given minimum_churn_count option" do
      churn = MetricFu::Churn.new( { :minimum_churn_count => 5 })
      churn.send(:build_churn_options).should == "--yaml --minimum_churn_count=5"
    end
  end


  describe "analyze method" do
    before :each do
      config_setup
      @changes = {"lib/generators/flog.rb" => 2, "lib/metric_fu.rb" => 3}
    end

    it "should be empty on error text" do
      churn = MetricFu::Churn.new
      churn.instance_variable_set(:@output, "Churning requires a subversion or git repo")
      result = churn.analyze
      result.should == {:churn => {}}
    end

    it "should be empty on error no output captured" do
      churn = MetricFu::Churn.new
      churn.instance_variable_set(:@output, nil)
      result = churn.analyze
      result.should == {:churn => {}}
    end

    it "should return yaml results" do
      churn = MetricFu::Churn.new
      churn.instance_variable_set(:@output, churn_yaml)
      result = churn.analyze
      result.should == {:churn => {:changed_files => ["spec/graphs/flog_grapher_spec.rb", "spec/base/graph_spec.rb", "lib/templates/awesome/layout.html.erb", "lib/graphs/rcov_grapher.rb", "lib/base/base_template.rb", "spec/graphs/grapher_spec.rb", "lib/templates/awesome/flog.html.erb", "lib/templates/awesome/flay.html.erb", "lib/graphs/roodi_grapher.rb", "lib/graphs/reek_grapher.rb", "HISTORY", "spec/graphs/roodi_grapher_spec.rb", "lib/generators/rcov.rb", "spec/graphs/engines/gchart_spec.rb", "spec/graphs/rcov_grapher_spec.rb", "lib/templates/javascripts/excanvas.js", "lib/templates/javascripts/bluff-min.js", "spec/graphs/reek_grapher_spec.rb"]}}
    end

  end


  describe "to_h method" do
    before :each do
      config_setup
    end

    it "should put the changes into a hash" do
      churn = MetricFu::Churn.new
      churn.instance_variable_set(:@churn, {:churn => 'results'})
      churn.to_h[:churn].should == "results"
    end
  end


  describe "emit method" do
    before :each do
      config_setup
      @churn = MetricFu::Churn.new
    end

    it "returns churn output" do
      @churn.stub(:churn_code).and_return("  master\n#{churn_yaml}")
      result = @churn.emit
      result.should == churn_yaml
    end

    it "returns nil, when churn result is not yaml" do
      @churn.stub(:churn_code).and_return("  master\n")
      result = @churn.emit
      result.should be nil
    end
  end
end


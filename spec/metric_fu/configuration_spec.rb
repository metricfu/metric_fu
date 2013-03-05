require "spec_helper"

describe MetricFu::Configuration do

  def get_new_config
    ENV['CC_BUILD_ARTIFACTS'] = nil
    @config = MetricFu.configuration
    @config.reset
    MetricFu.configure
    MetricFu.run_rcov
    @config.stub :create_directories # no need to create directories for the tests
    @config
  end

  def base_directory
    @config.send(:base_directory)
  end

  def output_directory
    @config.send(:output_directory)
  end

  def scratch_directory
    @config.send(:scratch_directory)
  end

  def template_directory
    @config.send(:template_directory)
  end

  def template_class
    @config.send(:template_class)
  end

  def metric_fu_root
    @config.send(:metric_fu_root_directory)
  end
  def load_metric(metric)
    load File.join(MetricFu.metrics_dir, metric, 'init.rb')
  end

  describe "#reset" do

    describe 'when there is a CC_BUILD_ARTIFACTS environment variable' do

      it 'should return the CC_BUILD_ARTIFACTS environment variable' do
        ENV['CC_BUILD_ARTIFACTS'] = 'foo'
        @config = MetricFu.configuration
        @config.reset
        MetricFu.configure
        compare_paths(base_directory, ENV['CC_BUILD_ARTIFACTS'])
      end
    end

    describe 'when there is no CC_BUILD_ARTIFACTS environment variable' do

      before(:each) do
        ENV['CC_BUILD_ARTIFACTS'] = nil
        get_new_config
      end
      it 'should return "tmp/metric_fu"' do
        base_directory.should == "tmp/metric_fu"
      end

      it 'should set @metric_fu_root_directory to the base of the '+
      'metric_fu application' do
        app_root = File.join(File.dirname(__FILE__), '..', '..')
        app_root_absolute_path = File.expand_path(app_root)
        metric_fu_absolute_path = File.expand_path(metric_fu_root)
        metric_fu_absolute_path.should == app_root_absolute_path
      end

      it 'should set @template_directory to the lib/templates relative '+
      'to @metric_fu_root_directory' do
        template_dir = File.join(File.dirname(__FILE__),
                                 '..', '..', 'lib','templates')
        template_dir_abs_path = File.expand_path(template_dir)
        calc_template_dir_abs_path = File.expand_path(template_directory)
        calc_template_dir_abs_path.should == template_dir_abs_path
      end

      it 'should set @scratch_directory to scratch relative '+
      'to @base_directory' do
        scratch_dir = MetricFu.scratch_dir
        scratch_directory.should == scratch_dir
      end

      it 'should set @output_directory to output relative '+
      'to @base_directory' do
        output_dir = MetricFu.output_dir
        output_directory.should == output_dir
      end

      it 'should set @template_class to AwesomeTemplate' do
        template_class.should == AwesomeTemplate
      end

      it 'should set @flay to {:dirs_to_flay => @code_dirs}' do
        load_metric 'flay'
        @config.send(:flay).
                should == {:dirs_to_flay => ['lib'], :filetypes=>["rb"], :minimum_score => 100}
      end

      it 'should set @flog to {:dirs_to_flog => @code_dirs}' do
        load_metric 'flog'
        @config.send(:flog).
                should == {:dirs_to_flog => ['lib']}
      end

      it 'should set @reek to {:dirs_to_reek => @code_dirs}' do
        load_metric 'reek'
        @config.send(:reek).
                should == {:config_file_pattern=>nil, :dirs_to_reek => ['lib']}
      end

      it 'should set @roodi to {:dirs_to_roodi => @code_dirs}' do
        load_metric 'roodi'
        @config.send(:roodi).
                should == { :dirs_to_roodi => MetricFu.code_dirs,
                    :roodi_config => "#{MetricFu.root_dir}/config/roodi_config.yml"}
      end

      it 'should set @churn to {}' do
        load_metric 'churn'
        @config.send(:churn).
                should == { :start_date => %q("1 year ago"), :minimum_churn_count => 10}
      end

      it 'should set @cane to ' +
                          %q(:dirs_to_cane => @code_dirs, :abc_max => 15, :line_length => 80, :no_doc => 'n') do
        load_metric 'cane'
        @config.send(:cane).
          should == {
            :dirs_to_cane => MetricFu.code_dirs,
            :filetypes => ["rb"],
            :abc_max => 15,
            :line_length => 80,
            :no_doc => "n"}
      end

      it 'should set @rcov to ' +
                            %q(:test_files =>  Dir['{spec,test}/**/*_{spec,test}.rb'],
                            :rcov_opts => [
                              "--sort coverage",
                              "--no-html",
                              "--text-coverage",
                              "--no-color",
                              "--profile",
                              "--exclude-only '.*'",
                              '--include-file "\Aapp,\Alib"',
                              "-Ispec"
                            ]) do
        load_metric 'rcov'
        @config.send(:rcov).
                should ==  { :environment => 'test',
                            :test_files =>  Dir['{spec,test}/**/*_{spec,test}.rb'],
                            :rcov_opts => [
                              "--sort coverage",
                              "--no-html",
                              "--text-coverage",
                              "--no-color",
                              "--profile",
                              "--exclude-only '.*'",
                              '--include-file "\Aapp,\Alib"',
                              "-Ispec"
                            ],
                            :external => nil}
      end

      it 'should set @saikuro to { :output_directory => @scratch_directory + "/saikuro",
                                   :input_directory => @code_dirs,
                                   :cyclo => "",
                                   :filter_cyclo => "0",
                                   :warn_cyclo => "5",
                                   :error_cyclo => "7",
                                   :formater => "text" }' do
        load_metric 'saikuro'
        @config.send(:saikuro).
                should ==  { :output_directory => "#{scratch_directory}/saikuro",
                      :input_directory => ['lib'],
                      :cyclo => "",
                      :filter_cyclo => "0",
                      :warn_cyclo => "5",
                      :error_cyclo => "7",
                      :formater => "text"}
      end

    end
    describe 'if #rails? is true ' do

      before(:each) do
        @config = MetricFu.configuration
        @config.stub!(:rails?).and_return(true)
        @config.reset
        MetricFu.configure
        %w(stats rails_best_practices).each do |metric|
          load_metric metric
        end
      end

      describe '#set_metrics ' do
        it 'should set the metrics to include stats' do
          @config.metrics.should include(:stats)
        end
      end

      describe '#set_graphs ' do
        if RUBY_VERSION < '1.9'
          it 'should not set the graphs to include rails_best_practices for ruby 1.8' do
            @config.graphs.should_not include(:rails_best_practices)
          end
        else
          it 'should set the graphs to include rails_best_practices' do
            @config.graphs.should include(:rails_best_practices)
          end
        end
      end

      describe '#set_code_dirs ' do
        it 'should set the @code_dirs instance var to ["app", "lib"]' do
          @config.send(:code_dirs).
                  should == ['app','lib']
        end
      end
      it 'should set @stats to {}' do
        load_metric 'stats'
        @config.send(:stats).
                should == {}
      end

      unless RUBY_VERSION < '1.9'
        it 'should set @rails_best_practices to {}' do
          load_metric 'rails_best_practices'
          @config.send(:rails_best_practices).
                  should == {}
        end
      end
    end

    describe 'if #rails? is false ' do
      before(:each) do
        get_new_config
        @config.stub!(:rails?).and_return(false)
        %w(stats rails_best_practices).each do |metric|
          load_metric metric
        end
      end

      it 'should set the available metrics' do
        @config.metrics.should =~ [:churn, :flog, :flay, :reek, :roodi, :rcov, :hotspots, :saikuro, :cane]
      end

      it 'should set the @code_dirs instance var to ["lib"]' do
        @config.send(:code_dirs).should == ['lib']
      end
    end
  end

  describe '#add_attr_accessors_to_self' do

    before(:each) { get_new_config }

    [:churn, :flog, :flay, :reek, :roodi, :rcov, :hotspots, :saikuro].each do |metric|
      it "should have a reader for #{metric}" do
        expect {
          @config.send(metric.to_sym)
        }.to_not raise_error
      end

      it "should have a writer for #{metric}=" do
        expect {
          @config.send((metric.to_s + '=').to_sym, '')
        }.to_not raise_error
      end
    end
  end

  describe '#add_class_methods_to_metric_fu' do

    before(:each) { get_new_config }

    [:churn, :flog, :flay, :reek, :roodi, :rcov, :hotspots, :saikuro, :cane].each do |metric|
      it "should add a #{metric} class method to the MetricFu module " do
        MetricFu.should respond_to(metric)
      end
    end

    [:churn, :flog, :flay, :reek, :roodi, :rcov, :hotspots, :saikuro, :cane].each do |graph|
      it "should add a #{graph} class metrhod to the MetricFu module" do
        MetricFu.should respond_to(graph)
      end
    end
  end

  describe '#platform' do

    before(:each) { get_new_config }

    it 'should return the value of the PLATFORM constant' do
      this_platform = RUBY_PLATFORM
      @config.platform.should == this_platform
    end
  end

  describe '#is_cruise_control_rb? ' do

    before(:each) { get_new_config }
    describe "when the CC_BUILD_ARTIFACTS env var is not nil" do

      before(:each) { ENV['CC_BUILD_ARTIFACTS'] = 'is set' }

      it 'should return true'  do
        @config.is_cruise_control_rb?.should be_true
      end

    end

    describe "when the CC_BUILD_ARTIFACTS env var is nil" do
      before(:each) { ENV['CC_BUILD_ARTIFACTS'] = nil }

      it 'should return false' do
        @config.is_cruise_control_rb?.should be_false
      end
    end
  end
end

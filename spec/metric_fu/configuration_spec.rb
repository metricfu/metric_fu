require "spec_helper"

describe MetricFu::Configuration do

  def get_new_config
    ENV['CC_BUILD_ARTIFACTS'] = nil
    @config = MetricFu.configuration
    @config.reset
    MetricFu.run_rcov
    MetricFu.configure
    mri_only_metrics = MetricFu.mri_only_metrics.reject {|metric| MetricFu::Metric.get_metric(metric).enabled }
    MetricFu.stub(:mri_only_metrics).and_return(mri_only_metrics)
    MetricFu::Io::FileSystem.stub(:create_directories) # no need to create directories for the tests
    @config
  end

  def directory(name)
    MetricFu::Io::FileSystem.directory(name)
  end

  def base_directory
    directory('base_directory')
  end

  def output_directory
    directory('output_directory')
  end

  def scratch_directory
    directory('scratch_directory')
  end

  def template_directory
    directory('template_directory')
  end

  def template_class
    MetricFu::Formatter::Templates.option('template_class')
  end

  def metric_fu_root
    directory('root_directory')
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
        expect(MetricFu::Metric.get_metric(:flay).run_options).to eq(
                {:dirs_to_flay => ['lib'], :filetypes=>["rb"], :minimum_score=>nil}
        )
      end

      it 'should set @reek to {:dirs_to_reek => @code_dirs}' do
        load_metric 'reek'
        expect(MetricFu::Metric.get_metric(:reek).run_options).to eq(
                {:config_file_pattern=>nil, :dirs_to_reek => ['lib']}
        )
      end

      it 'should set @roodi to {:dirs_to_roodi => @code_dirs}' do
        load_metric 'roodi'
        expect(MetricFu::Metric.get_metric(:roodi).run_options).to eq(
                { :dirs_to_roodi => directory('code_dirs'),
                    :roodi_config => "#{directory('root_directory')}/config/roodi_config.yml"}
                )
      end

      it 'should set @churn to {}' do
        load_metric 'churn'
        expect(MetricFu::Metric.get_metric(:churn).run_options).to eq(
                { :start_date => %q("1 year ago"), :minimum_churn_count => 10}
        )
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
        expect(MetricFu::Metric.get_metric(:rcov).run_options).to eq(
                { :environment => 'test',
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
        )
      end

      it 'should set @saikuro to { :output_directory => @scratch_directory + "/saikuro",
                                   :input_directory => @code_dirs,
                                   :cyclo => "",
                                   :filter_cyclo => "0",
                                   :warn_cyclo => "5",
                                   :error_cyclo => "7",
                                   :formater => "text" }' do
        load_metric 'saikuro'
        expect(MetricFu::Metric.get_metric(:saikuro).run_options).to eq(
                { :output_directory => "#{scratch_directory}/saikuro",
                      :input_directory => ['lib'],
                      :cyclo => "",
                      :filter_cyclo => "0",
                      :warn_cyclo => "5",
                      :error_cyclo => "7",
                      :formater => "text"}
                      )
      end

      if MetricFu.configuration.mri?
        it 'should set @flog to {:dirs_to_flog => @code_dirs}' do
          load_metric 'flog'
          expect(MetricFu::Metric.get_metric(:flog).run_options).to eq(
                  {:dirs_to_flog => ['lib']}
                  )
        end
        it 'should set @cane to ' +
                            %q(:dirs_to_cane => @code_dirs, :abc_max => 15, :line_length => 80, :no_doc => 'n', :no_readme => 'y') do
          load_metric 'cane'
          expect(MetricFu::Metric.get_metric(:cane).run_options).to eq(
            {
              :dirs_to_cane => directory('code_dirs'),
              :filetypes => ["rb"],
              :abc_max => 15,
              :line_length => 80,
              :no_doc => "n",
              :no_readme => "n"}
              )
        end
      end


    end
    describe 'if #rails? is true ' do

      before(:each) do
        @config = MetricFu.configuration
        @config.stub(:rails?).and_return(true)
        @config.reset
        MetricFu.configure
        %w(stats rails_best_practices).each do |metric|
          load_metric metric
        end
      end

      describe '#set_metrics ' do
        it 'should set the metrics to include stats' do
          MetricFu::Metric.enabled_metrics.map(&:name).should include(:stats)
        end
      end

      describe '#set_graphs ' do
        it 'should set the graphs to include rails_best_practices' do
          expect(MetricFu::Metric.get_metric(:rails_best_practices).has_graph?).to be_true
        end
      end

      describe '#set_code_dirs ' do
        it 'should set the @code_dirs instance var to ["app", "lib"]' do
          directory('code_dirs').
                  should == ['app','lib']
        end
      end
      it 'should set @stats to {}' do
        load_metric 'stats'
        MetricFu::Metric.get_metric(:stats).run_options.
                should == {}
      end

      it 'should set @rails_best_practices to {}' do
        load_metric 'rails_best_practices'
        expect(MetricFu::Metric.get_metric(:rails_best_practices).run_options).to eql({})
      end
    end

    describe 'if #rails? is false ' do
      before(:each) do
        get_new_config
        @config.stub(:rails?).and_return(false)
        %w(stats rails_best_practices).each do |metric|
          load_metric metric
        end
      end

      it 'should set the available metrics' do
        MetricFu::Metric.enabled_metrics.map(&:name).should =~ [:churn, :flog, :flay, :reek, :roodi, :rcov, :hotspots, :saikuro, :cane] - MetricFu.mri_only_metrics
      end

      it 'should set the @code_dirs instance var to ["lib"]' do
        directory('code_dirs').should == ['lib']
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

  describe '#configure_formatter' do
    before(:each) { get_new_config }

    context 'given a built-in formatter' do
      before do
        @config.configure_formatter('html')
      end

      it 'adds to the list of formatters' do
        @config.formatters.first.should be_an_instance_of(MetricFu::Formatter::HTML)
      end
    end

    context 'given a custom formatter by class name' do
      before do
        stub_const('MyCustomFormatter', Class.new() { def initialize(*); end })
        @config.configure_formatter('MyCustomFormatter')
      end

      it 'adds to the list of formatters' do
        @config.formatters.first.should be_an_instance_of(MyCustomFormatter)
      end
    end

    context 'given multiple formatters' do
      before do
        stub_const('MyCustomFormatter', Class.new() { def initialize(*); end })
        @config.configure_formatter('html')
        @config.configure_formatter('yaml')
        @config.configure_formatter('MyCustomFormatter')
      end

      it 'adds each to the list of formatters' do
        @config.formatters.count.should eq(3)
      end
    end
  end
end

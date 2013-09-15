require "spec_helper"

describe MetricFu::SaikuroGenerator do
  describe "to_h method" do
    before :all do
      options = {}
      saikuro = MetricFu::SaikuroGenerator.new(options)
      def saikuro.metric_directory
        "#{resources_path}/saikuro"
      end
      saikuro.analyze
      @output = saikuro.to_h
    end

    it "should find the filename of a file" do
      @output[:saikuro][:files].first[:filename].should == 'app/controllers/users_controller.rb'
    end

    it "should find the name of the classes" do
      @output[:saikuro][:classes].first[:name].should == "UsersController"
      @output[:saikuro][:classes][1][:name].should == "SessionsController"
    end

    it "should put the most complex method first" do
      @output[:saikuro][:methods].first[:name].should == "UsersController#create"
      @output[:saikuro][:methods].first[:complexity].should == 4
    end

    it "should find the complexity of a method" do
      @output[:saikuro][:methods].first[:complexity].should == 4
    end

    it "should find the lines of a method" do
      @output[:saikuro][:methods].first[:lines].should == 15
    end
  end

  describe "per_file_info method" do
    before :all do
      options = {}
      @saikuro = MetricFu::SaikuroGenerator.new(options)
      def @saikuro.metric_directory
        "#{resources_path}/saikuro"
      end
      @saikuro.analyze
      @output = @saikuro.to_h
    end

    it "doesn't try to get information if the file does not exist" do
      File.should_receive(:exists?).at_least(:once).and_return(false)
      @saikuro.per_file_info('ignore_me')
    end
  end

  describe MetricFu::SaikuroScratchFile do
    describe "getting elements from a Saikuro result file" do
     it "should parse nested START/END sections" do
       path = "#{resources_path}/saikuro_sfiles/thing.rb_cyclo.html"
        sfile = MetricFu::SaikuroScratchFile.new path
       sfile.elements.map { |e| e.complexity }.sort.should eql(["0","0","2"])
      end
    end
  end
end

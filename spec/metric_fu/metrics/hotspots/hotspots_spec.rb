require "spec_helper"

describe MetricFu::HotspotsGenerator do

  describe "analyze method" do
    before :each do
      MetricFu::Configuration.run {}
      File.stub(:directory?).and_return(true)
      @yaml = metric_data('hotspots/generator.yml')
    end

    it "should be empty on error" do
      hotspots = MetricFu::HotspotsGenerator.new
      hotspots.instance_variable_set(:@analyzer, nil)
      result = hotspots.analyze
      result.should == {:files => [], :classes => [], :methods => []}
    end

    it "should put the changes into a hash" do
      MetricFu.result.should_receive(:result_hash).and_return(@yaml)
      hotspots = MetricFu::HotspotsGenerator.new
      hotspots.analyze
      result = hotspots.to_h[:hotspots]
      expected = metric_data('hotspots/generator_analysis.yml')
      # ensure expected granularities
      expect(result.keys).to eq(expected.keys)

      # for each granularity's location details
      result.each do |granularity,location_details|
        # map 2d array for this granularity of [details, location]
        expected_result = expected.fetch(granularity).map {|ld| [ld.fetch('details'), ld.fetch('location')] }
        # verify all the location details for this granularity match elements of expected_result
        location_details.each do |location_detail|
          location = location_detail.fetch('location')
          details  = location_detail.fetch('details')
          # get the location_detail array where the  where the locations (second element) match
          expected_location_details = expected_result.rassoc(location)
          # get the details (first element) from the expected location_details array
          expected_details = expected_location_details[0]
          expect(details).to eq(expected_details)
        end
      end
    end

    # really testing the output of analyzed_problems#worst_items
    it "should return the worst item granularities: files, classes, methods" do
      hotspots = MetricFu::HotspotsGenerator.new
      analyzer = HotspotAnalyzer.new(@yaml)
      expect(hotspots.analyze.keys).to eq([:files, :classes, :methods])
    end
  end

end

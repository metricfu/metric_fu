require 'spec_helper'
require 'yaml'

describe MetricFu::ReekExaminer do

  context 'get the right reek examiner' do

    let(:options) { { dirs_to_reek: [] } }
    let(:files_to_analyze) { ['lib/metric_fu/version.rb'] }

    before :each do
      allow(ReekExaminer).to receive(:reek_examinor_klass).and_return(class_double('Reek::Examiner'))
    end

    it 'Reek version ~1.0 creates a ReekExaminerV1 object' do
      allow(ReekExaminer).to receive(:reek_version).and_return('1.6.6')
      examiner = MetricFu::ReekExaminer.get
      expect(examiner).to be_a(MetricFu::ReekExaminer::ReekExaminerV1)
    end

    it 'Reek version ~2.0 creates a ReekExaminerV1 object' do
      allow(ReekExaminer).to receive(:reek_version).and_return('2.2.1')
      examiner = MetricFu::ReekExaminer.get
      expect(examiner).to be_a(MetricFu::ReekExaminer::ReekExaminerV1)
    end

    it 'Reek version ~3.0 creates a ReekExaminerV3 object' do
      allow(ReekExaminer).to receive(:reek_version).and_return('3.11')
      examiner = MetricFu::ReekExaminer.get
      expect(examiner).to be_a(MetricFu::ReekExaminer::ReekExaminerV3)
    end

    it 'Reek version ~4.0 creates a ReekExaminerV4 object' do
      allow(ReekExaminer).to receive(:reek_version).and_return('4.1.0')
      examiner = MetricFu::ReekExaminer.get
      expect(examiner).to be_a(MetricFu::ReekExaminer::ReekExaminerV4)
    end
  end

  context 'Analyse Reek Examiner' do
    let(:reek_version) { Gem::Specification.find_by_name('reek').version }
    let(:expect_code_smells) {
      [
        {
          :method=>"MetricFu",
          :message=>"has no descriptive comment",
          :type=>"IrresponsibleModule",
          :lines=>[5]
        },
        {
          :method=>"MetricFu#run_only",
          :message=>"contains iterators nested 2 deep",
          :type=>"NestedIterators",
          :lines=>[129]
        },
        {
          :method=>"MetricFu#run_only",
          :message=>"has approx 9 statements",
          :type=>"TooManyStatements",
          :lines=>[126]
        }
      ]
    }

    describe 'Reek V1', :skip => !gem_match_version('reek', '~> 1.0') do
      let(:output) {
        fixture_file = FIXTURE.fixtures_path.join('reek', 'examiner_1.6.6.yml').to_s
        YAML::load_file(fixture_file)
      }

      it 'analyse parses to propper mf_reek model' do
        sut = MetricFu::ReekExaminer::ReekExaminerV1.new(double)
        sut.instance_variable_set(:@output, output)
        expect(sut.analyze).to be_a(Array)
        expect(sut.analyze.count).to eq(1)
        expect(sut.analyze.first[:code_smells]).to include(*expect_code_smells)
      end
    end

    describe 'Reek V2', :skip => !gem_match_version('reek', '~> 2.0') do
      let(:output) {
        fixture_file = FIXTURE.fixtures_path.join('reek', 'examiner_2.2.1.yml').to_s
        YAML::load_file(fixture_file)
      }

      it 'analyse parses to propper mf_reek model' do
        sut = MetricFu::ReekExaminer::ReekExaminerV1.new(double)
        sut.instance_variable_set(:@output, output)
        expect(sut.analyze).to be_a(Array)
        expect(sut.analyze.count).to eq(1)
        expect(sut.analyze.first[:code_smells]).to include(*expect_code_smells)
      end
    end

    describe 'Reek V3', :skip => !gem_match_version('reek', '~> 3.0') do
      let(:output) {
        fixture_file = FIXTURE.fixtures_path.join('reek', 'examiner_3.11.yml').to_s
        YAML::load_file(fixture_file)
      }

      it 'analyse parses to propper mf_reek model' do
        sut = MetricFu::ReekExaminer::ReekExaminerV3.new(double)
        sut.instance_variable_set(:@output, output)
        expect(sut.analyze).to be_a(Array)
        expect(sut.analyze.count).to eq(1)
        expect(sut.analyze.first[:code_smells]).to include(*expect_code_smells)
      end
    end

    describe 'Reek V4', :skip => !gem_match_version('reek', '~> 4.0') do
      let(:output) {
        fixture_file = FIXTURE.fixtures_path.join('reek', 'examiner_4.1.0.yml').to_s
        YAML::load_file(fixture_file)
      }

      it 'analyse parses to propper mf_reek model' do
        sut = MetricFu::ReekExaminer::ReekExaminerV4.new(double)
        sut.instance_variable_set(:@output, output)
        expect(sut.analyze).to be_a(Array)
        expect(sut.analyze.count).to eq(1)
        expect(sut.analyze.first[:code_smells]).to include(*expect_code_smells)
      end
    end
  end
end

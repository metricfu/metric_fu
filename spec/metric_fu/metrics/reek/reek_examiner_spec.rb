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
    let(:options) { { } }
    let(:files_to_analyze) { Dir[run_dir + '/**/bad_code.rb'] }
    let(:expect_code_smells) {
      [
        {
          :method=>"BadCode",
          :message=>"has no descriptive comment",
          :type=>"IrresponsibleModule",
          :lines=>[1]
        },
        {
          :method=>"BadCode#nonsense",
          :message=>"has approx 7 statements",
          :type=>"TooManyStatements",
          :lines=>[2]
        },
        {
          :method=>"BadCode#nonsense",
          :message=>"has the variable name 'x'",
          :type=>"UncommunicativeVariableName",
          :lines=>[3]
        },
        {
          :method=>"BadCode#nonsense",
          :message=>"contains iterators nested 2 deep",
          :type=>"NestedIterators",
          :lines=>[5]
        }
      ]
    }

    it 'analyse parses to propper mf_reek model' do
      sut = MetricFu::ReekExaminer.get
      sut.run!(files_to_analyze, options)
      expect(sut.analyze).to be_a(Array)
      expect(sut.analyze.count).to eq(1)
      expect(sut.analyze.first[:code_smells]).to include(*expect_code_smells)
    end
  end
end

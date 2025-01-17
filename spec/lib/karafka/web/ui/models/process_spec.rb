# frozen_string_literal: true

RSpec.describe_current do
  let(:state) { JSON.parse(fixtures_file('consumers_state.json'), symbolize_names: true) }
  let(:report) { JSON.parse(fixtures_file('consumer_report.json'), symbolize_names: true) }
  let(:reports_topic) { create_topic }

  before do
    Karafka::Web.config.topics.consumers.reports = reports_topic
    produce(reports_topic, report.to_json)
  end

  describe '.find' do
    subject(:lookup) { described_class.find(state, process_id) }

    context 'when process with given id does not exist in the state' do
      let(:process_id) { SecureRandom.uuid }

      it { expect { lookup }.to raise_error(::Karafka::Web::Errors::Ui::NotFoundError) }
    end

    context 'when process exists' do
      let(:process_id) { '1' }

      it { expect(lookup).to be_a(described_class) }
    end
  end

  describe 'process attributes' do
    subject(:process) { described_class.find(state, '1') }

    it 'expect to have valid attributes configured' do
      expect(process.id).to eq('1')
      expect(process.consumer_groups.size).to eq(2)
      cgs = %w[example_app6_app example_app6_karafka_web]
      expect(process.consumer_groups.map(&:id)).to eq(cgs)
      expect(process.jobs.size).to eq(1)
      expect(process.jobs.first.started_at).to eq(1_690_883_271.5_342_352)
      expect(process.lag_stored).to eq(1)
      expect(process.lag).to eq(13)
      expect(process.subscribed_partitions_count).to eq(3)
    end
  end
end

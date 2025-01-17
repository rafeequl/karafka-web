# frozen_string_literal: true

RSpec.describe_current do
  let(:metrics_topic) { Karafka::Web.config.topics.consumers.metrics = create_topic }
  let(:fixture) { fixtures_file('consumers_metrics.json') }

  describe '#current!' do
    subject(:metrics) { described_class.current! }

    before { metrics_topic }

    context 'when there is no current state' do
      let(:expected_error) { ::Karafka::Web::Errors::Processing::MissingConsumersMetricsError }

      it { expect { metrics }.to raise_error(expected_error) }
    end

    context 'when current state exists' do
      before { produce(metrics_topic, fixture) }

      it 'expect to get it with the data inside' do
        expect(metrics).to be_a(Hash)
        expect(metrics.key?(:aggregated)).to eq(true)
        expect(metrics.key?(:consumer_groups)).to eq(true)
        expect(metrics.key?(:schema_version)).to eq(true)
        expect(metrics.key?(:dispatched_at)).to eq(true)
      end
    end
  end
end

RSpec.describe Jekyll::Drops::Plugins::Examples::Yaml do
  let(:example) do
    SafeYAML.load(
      File.read('app/_src/.repos/kong-plugins/examples/opentelemetry/_3.2.x.yaml')
    )
  end

  subject { described_class.new(type:, example:) }

  describe '#example_config' do
    let(:type) { 'consumer' }

    it 'returns an array with the config in yaml format' do
      expect(subject.example_config).to eq([
        'endpoint: http://opentelemetry.collector:4318/v1/traces',
        'headers:',
        '  X-Auth-Token: secret-token'
      ])
    end
  end

  describe '#type_field' do
    context 'type consumer' do
      let(:type) { 'consumer' }

      it { expect(subject.type_field).to eq('consumer: CONSUMER_NAME|CONSUMER_ID') }
    end

    context 'type global' do
      let(:type) { 'global' }

      it { expect(subject.type_field).to be_nil }
    end

    context 'type route' do
      let(:type) { 'route' }

      it { expect(subject.type_field).to eq('route: ROUTE_NAME') }
    end

    context 'type service' do
      let(:type) { 'service' }

      it { expect(subject.type_field).to eq('service: SERVICE_NAME|SERVICE_ID') }
    end
  end
end

RSpec.describe Jekyll::Drops::Plugins::Examples::Curl do
  let(:type) {}
  let(:example) do
    SafeYAML.load(
      File.read('app/_src/.repos/kong-plugins/examples/acme/_3.2.x.yaml')
    )
  end

  subject { described_class.new(type:, example:) }

  describe '#params' do
    it 'returns the list of params defined on the example' do
      expect(subject.params.size).to eq(2)
      expect(subject.params).to all(be_an(Jekyll::Drops::Plugins::Examples::Fields::Curl))

      expect(subject.params.map(&:to_s)).to match_array([
        "name=acme",
        "config.account_email=example@example.com"
      ])
    end
  end

  describe '#url' do
    context 'type consumer' do
      let(:type) { 'consumer' }

      it { expect(subject.url).to eq('http://localhost:8001/consumers/CONSUMER_NAME|CONSUMER_ID/plugins') }
    end

    context 'type global' do
      let(:type) { 'global' }

      it { expect(subject.url).to eq('http://localhost:8001/plugins/') }
    end

    context 'type route' do
      let(:type) { 'route' }

      it { expect(subject.url).to eq('http://localhost:8001/routes/ROUTE_NAME|ROUTE_ID/plugins') }
    end

    context 'type service' do
      let(:type) { 'service' }

      it { expect(subject.url).to eq('http://localhost:8001/services/SERVICE_NAME|SERVICE_ID/plugins') }
    end
  end
end

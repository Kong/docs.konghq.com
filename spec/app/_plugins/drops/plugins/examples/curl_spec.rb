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
      expect(subject.params).to eq(
        "name" => "acme",
        "config" => { "account_email" => "example@example.com" }
      )
    end
  end

  describe '#url' do
    context 'type consumer' do
      let(:type) { 'consumer' }

      it { expect(subject.url).to eq('http://localhost:8001/consumers/{consumerName|Id}/plugins') }
    end

    context 'type global' do
      let(:type) { 'global' }

      it { expect(subject.url).to eq('http://localhost:8001/plugins/') }
    end

    context 'type route' do
      let(:type) { 'route' }

      it { expect(subject.url).to eq('http://localhost:8001/routes/{routeName|Id}/plugins') }
    end

    context 'type service' do
      let(:type) { 'service' }

      it { expect(subject.url).to eq('http://localhost:8001/services/{serviceName|Id}/plugins') }
    end
  end
end

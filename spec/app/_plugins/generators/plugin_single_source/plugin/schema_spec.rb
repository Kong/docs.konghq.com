RSpec.describe PluginSingleSource::Plugin::Schema do
  let(:plugin_name) { 'acme'}
  let(:acme_schema) { JSON.parse(File.read('app/_src/.repos/kong-plugins/schemas/acme/3.1.x.json')) }
  let(:version) { '3.1.1' }

  subject { described_class.new(plugin_name:, version:) }

  describe '#schema' do
    it 'returns the corresponding schema in JSON format' do
      expect(File)
        .to receive(:read)
        .with('app/_src/.repos/kong-plugins/schemas/acme/3.1.x.json').and_call_original
        .twice

      expect(subject.schema).to eq(acme_schema)
    end
  end

  describe '#fields' do
    it 'returns the schema\'s fields' do
      expect(subject.fields).to eq(acme_schema['fields'])
    end
  end

  describe '#config' do
    it 'returns the field `config` defined in the schema' do
      config = acme_schema['fields'].detect { |f| f.key?('config') }
      expect(subject.config).to eq(config['config'])
    end
  end

  describe '#example' do
    xit 'it returns a valid example'
  end

  describe '#enable_on_consumer?' do
    context 'when the plugin has { consumer = typedefs.no_consumer } set' do
      let(:plugin_name) { 'acme' }
      it { expect(subject.enable_on_consumer?).to eq(false) }
    end

    context 'when it does not have { consumer = typedefs.no_consumer } set' do
      let(:plugin_name) { 'zipkin' }
      it { expect(subject.enable_on_consumer?).to eq(true) }
    end
  end

  describe '#enable_on_service?' do
    context 'when the plugin has { service = typedefs.no_service } set' do
      let(:plugin_name) { 'acme' }
      it { expect(subject.enable_on_service?).to eq(false) }
    end

    context 'when it does not have { service = typedefs.no_service } set' do
      let(:plugin_name) { 'zipkin' }
      it { expect(subject.enable_on_service?).to eq(true) }
    end
  end

  describe '#enable_on_route?' do
    context 'when the plugin has { route = typedefs.no_route } set' do
      let(:plugin_name) { 'acme' }
      it { expect(subject.enable_on_route?).to eq(false) }
    end

    context 'when it does not have { route = typedefs.no_route } set' do
      let(:plugin_name) { 'zipkin' }
      it { expect(subject.enable_on_route?).to eq(true) }
    end
  end

  describe '#protocols' do
    let(:plugin_name) { 'datadog' }

    it 'returns the protocols defined in the schema' do
      expect(subject.protocols).to match_array([
        'grpc', 'grpcs', 'http', 'https','tcp','tls',
        'tls_passthrough', 'udp', 'ws', 'wss'
      ])
    end
  end
end

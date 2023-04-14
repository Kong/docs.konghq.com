RSpec.describe PluginSingleSource::Plugin::Schemas::ThirdParty do
  let(:plugin_name) { 'kong-plugin'}
  let(:vendor) { 'acme' }
  let(:schema) { JSON.parse(File.read('spec/fixtures/app/_hub/acme/kong-plugin/schemas/_index.json')) }
  let(:version) { '3.1.1' }

  subject { described_class.new(plugin_name:, vendor:, version:) }

  before do
    allow(subject)
      .to receive(:file_path)
      .and_return('spec/fixtures/app/_hub/acme/kong-plugin/schemas/_index.json')
  end

  describe '#schema' do
    it 'returns the corresponding schema in JSON format' do
      expect(subject.schema).to eq(schema)
    end
  end

  describe '#fields' do
    it 'returns the schema\'s fields' do
      expect(subject.fields).to eq(schema['fields'])
    end
  end

  describe '#config' do
    it 'returns the field `config` defined in the schema' do
      config = schema['fields'].detect { |f| f.key?('config') }
      expect(subject.config).to eq(config['config'])
    end
  end

  describe '#example' do
    it 'it returns the corresponding example' do
      expect(subject.example)
        .to eq(YAML.load(File.read('spec/fixtures/app/_hub/acme/kong-plugin/examples/_index.yml')))
    end

    context 'when the file does not exist' do
      let(:plugin_name) { 'unbundled-plugin' }
      it { expect(subject.example).to be nil }
    end
  end

  describe '#enable_on_consumer?' do
    it { expect(subject.enable_on_consumer?).to eq(true) }
  end

  describe '#enable_on_service?' do
    it { expect(subject.enable_on_service?).to eq(false) }
  end

  describe '#enable_on_route?' do
    it { expect(subject.enable_on_route?).to eq(false) }
  end

  describe '#protocols' do
    it 'returns the protocols defined in the schema' do
      expect(subject.protocols).to match_array(['http', 'https'])
    end
  end
end

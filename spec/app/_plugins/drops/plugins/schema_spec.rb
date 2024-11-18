RSpec.describe Jekyll::Drops::Plugins::Schema do
  let(:plugin_name) { 'application-registration' }
  let(:metadata_file) { 'app/_hub/kong-inc/application-registration/_metadata/_index.yml' }
  let(:metadata) { SafeYAML.load(File.read(metadata_file)) }
  let(:version) { '3.1.1' }
  let(:schema) do
    PluginSingleSource::Plugin::Schemas::Kong.new(
      plugin_name: plugin_name,
      vendor: 'kong-inc',
      version: version,
      site:
    )
  end

  subject { described_class.new(schema:, metadata:) }

  describe '#global?' do
    context 'returns true if the metadata does not have the `global` key' do
      let(:plugin_name) { 'acme' }
      let(:metadata_file) { 'app/_hub/kong-inc/acme/_metadata/_index.yml' }

      it { expect(subject.global?).to eq(true) }
    end

    context 'returns the value of `global` present in the metadata' do
      it { expect(subject.global?).to eq(false) }
    end
  end

  describe '#api_id' do
    context 'returns the value of `api_id` present in the metadata' do
      let(:metadata) { { 'api_id' => true } }

      it { expect(subject.api_id).to eq(true) }
    end
  end

  describe '#fields' do
    it 'returns an array containing the schema\'s fields - only config for now' do
      expect(subject.fields.size).to eq(1)
      expect(subject.fields.first.name).to eq('config')
    end
  end

  describe '#shorthand_fields' do
    let(:plugin_name) { 'saml' }
    let(:version) { '3.2.2' }
    let(:metadata_file) { 'app/_hub/kong-inc/saml/_metadata/_index.yml' }

    it 'returns an array containing the schema\'s shorthand_fields' do
      expect(subject.shorthand_fields.size).to eq(14)
    end
  end

  describe '#enable_on_consumer?' do
    it 'delegates to schema' do
      expect(subject.enable_on_consumer?).to eq(schema.enable_on_consumer?)
    end
  end

  describe '#enable_on_route?' do
    it 'delegates to schema' do
      expect(subject.enable_on_route?).to eq(schema.enable_on_route?)
    end
  end

  describe '#enable_on_service?' do
    it 'delegates to schema' do
      expect(subject.enable_on_service?).to eq(schema.enable_on_service?)
    end
  end

  describe '#global?' do
    context 'when the `global` is defined in the metadata' do
      it { expect(subject.global?).to eq(false) }
    end

    context 'when it is not' do
      let(:plugin_name) { 'acme' }
      let(:metadata_file) { 'app/_hub/kong-inc/acme/_metadata/_index.yml' }

      it { expect(subject.global?).to eq(true) }
    end
  end

  describe '#defined?' do
    context 'when there is a schema present' do
      it { expect(subject.defined?).to eq(true) }
    end

    context 'when there is not one' do
      before do
        allow(schema).to receive(:config).and_return({})
      end

      it { expect(subject.defined?).to eq(false) }
    end
  end
end

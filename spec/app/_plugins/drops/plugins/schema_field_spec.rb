RSpec.describe Jekyll::Drops::Plugins::SchemaField do
  let(:name) { 'config' }
  let(:parent) { '' }
  let(:field_schema) { schema.config }
  let(:plugin_name) { 'saml' }
  let(:version) { '3.2.2' }
  let(:schema) do
    PluginSingleSource::Plugin::Schemas::Kong.new(
      plugin_name: plugin_name,
      vendor: 'kong-inc',
      version: version,
      site:
    )
  end

  subject do
    described_class.new(name: , parent: , schema: field_schema)
  end

  describe '#anchor' do
    it 'returns the anchor link' do
      expect(subject.anchor).to eq('config')
    end

    context 'nested field' do
      let(:name) { 'session_redis_cluster_nodes' }
      let(:nested_field) { schema.config['fields'].detect { |f| f.key?(name) } }
      let(:parent) { 'config' }
      let(:field_schema) { nested_field.values.first }

      it 'returns the anchor link' do
        expect(subject.anchor).to eq('config-session_redis_cluster_nodes')
      end
    end
  end

  describe '#elements' do
    it 'returns the hash of elements that the field has' do
      expect(subject.elements).to eq({})
    end

    context 'field with elements' do
      let(:name) { 'session_redis_cluster_nodes' }
      let(:nested_field) { schema.config['fields'].detect { |f| f.key?(name) } }
      let(:parent) { 'config' }
      let(:field_schema) { nested_field.values.first }

      it 'generated SchemaFields for every field' do
        expect(subject.elements['fields'].size).to eq(2)
        expect(subject.elements['fields']).to all(be_an(described_class))
      end
    end
  end

  describe '#fields' do
    it 'returns the list of `fields`' do
      expect(subject.fields.size).to eq(54)
      expect(subject.fields).to all(be_an(described_class))
    end
  end

  describe '#referenceable' do
    context 'when the field is referenceable' do
      let(:name) { 'token' }
      let(:parent) { 'vault' }
      let(:field_schema) { { "referenceable" => true, "type" => "string" } }

      it { expect(subject.referenceable).to eq(true) }
    end

    context 'when the field is of type array and its elements are referenceable' do
      let(:name) { 'body' }
      let(:parent) { 'rename' }
      let(:field_schema) do
        {
          "default" => [],
          "type" => "array",
          "elements" => { "type" => "string", "referenceable" => true },
          "description" => "List of parameters..."
        }
      end

      it { expect(subject.referenceable).to eq(true) }
    end
  end

  describe '#deprecated?' do
    context 'when the field has a `deprecation` key' do
      let(:name) { 'proxy_host' }
      let(:parent) { 'shorthand_fields' }
      let(:field_schema) { schema.config[parent].detect { |f| f.key?(name) }[name] }
      let(:schema) do
        PluginSingleSource::Plugin::Schemas::Kong.new(
          plugin_name: 'forward-proxy',
          vendor: 'kong-inc',
          version: '3.7.0',
          site:
        )
      end

      it { expect(subject.deprecated?).to eq(true) }
    end

    context 'when the field does not have a `deprecation` key' do
      it { expect(subject.deprecated?).to eq(false) }
    end
  end

  describe '#deprecation' do
    context 'when the field has a `deprecation` key' do
      let(:name) { 'proxy_host' }
      let(:parent) { 'shorthand_fields' }
      let(:field_schema) { schema.config[parent].detect { |f| f.key?(name) }[name] }
      let(:schema) do
        PluginSingleSource::Plugin::Schemas::Kong.new(
          plugin_name: 'forward-proxy',
          vendor: 'kong-inc',
          version: '3.7.0',
          site:
        )
      end
      it 'returns the value of the `deprecation` key' do
        schema = JSON.parse(File.read('app/_src/.repos/kong-plugins/schemas/forward-proxy/3.7.x.json'))
        shorthand_fields = schema['fields'].detect { |f| f.key?('config') }.dig('config', 'shorthand_fields')
        field = shorthand_fields.detect { |f| f.key?(name) }[name]

        expect(subject.deprecation).to eq(field['deprecation'])
      end
    end

    context 'when the field does not have a `deprecation` key' do
      it { expect(subject.deprecation).to be_nil }
    end
  end
end

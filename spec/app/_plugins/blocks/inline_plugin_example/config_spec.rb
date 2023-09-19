RSpec.describe Jekyll::InlinePluginExample::Config do
  let(:page) { { 'kong_version' => '3.2.x' } }
  let(:config) do
    SafeYAML.load(
      <<~CONFIG
        title: Opinionated Example
        plugin: kong-inc/jwt-signer
        name: jwt-signer
        config:
          access_token_introspection_scopes_claim:
            - scope
            - realm_access
        targets:
          - service
          - route
          - consumer
          - global
        formats:
          - curl
          - yaml
          - kubernetes
      CONFIG
    )
  end

  subject { described_class.new(config:, page:) }

  describe '#plugin' do
    it { expect(subject.plugin).to eq('kong-inc/jwt-signer') }
  end

  describe '#targets' do
    it { expect(subject.targets).to match_array([:service, :route, :consumer, :global]) }
  end

  describe '#formats' do
    it { expect(subject.formats).to match_array([:curl, :yaml, :kubernetes]) }
  end

  describe '#example' do
    it 'returns the provided example' do
      expect(subject.example)
        .to eq({ 'name' => 'jwt-signer', 'config' => { 'access_token_introspection_scopes_claim' => ['scope', 'realm_access'] } })
    end
  end

  describe 'validations' do
    context 'when one of the targets is not valid' do
      let(:config) do
        SafeYAML.load(
          <<~CONFIG
        plugin: kong-inc/jwt-signer
        name: jwt-signer
        config:
          access_token_introspection_scopes_claim:
            - scope
            - realm_access
        targets:
          - invalid-target
        formats:
          - curl
          - yaml
          - kubernetes
          CONFIG
        )
      end

      it { expect{ subject }.to raise_error(ArgumentError) }
    end

    context 'when one of the formats is not valid' do
      let(:config) do
        SafeYAML.load(
          <<~CONFIG
        plugin: kong-inc/jwt-signer
        name: jwt-signer
        config:
          access_token_introspection_scopes_claim:
            - scope
            - realm_access
        targets:
          - service
          - route
          - consumer
          - global
        formats:
          - invalid
          CONFIG
        )
      end

      it { expect{ subject }.to raise_error(ArgumentError) }
    end
  end

  describe '#title' do
    it { expect(subject.title).to eq('Opinionated Example') }
  end

  describe '#schema' do
    context 'when the page has `version` set instead of `kong_version`' do
      let(:page) { { 'version' => '3.2.x' } }

      it 'returns the schema' do
        expect(subject.schema).to be_an_instance_of(::PluginSingleSource::Plugin::Schemas::Kong)
      end
    end

    context 'when the page has `kong_version` set' do
      let(:page) { { 'kong_version' => '3.2.x' } }

      it 'returns the schema' do
        expect(subject.schema).to be_an_instance_of(::PluginSingleSource::Plugin::Schemas::Kong)
      end
    end
  end
end

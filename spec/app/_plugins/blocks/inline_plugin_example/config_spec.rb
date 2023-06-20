RSpec.describe Jekyll::InlinePluginExample::Config do
  let(:page) { { 'kong_version' => '3.2.x' } }
  let(:config) do
    SafeYAML.load(
      <<~CONFIG
        name: jwt-signer-example
        plugin: kong-inc/jwt-signer
        example: complex-example
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

  describe '#name' do
    it { expect(subject.name).to eq('jwt-signer-example') }
  end

  describe '#plugin' do
    it { expect(subject.plugin).to eq('kong-inc/jwt-signer') }
  end

  describe '#example_name' do
    it { expect(subject.example_name).to eq('complex-example') }
  end

  describe '#targets' do
    it { expect(subject.targets).to match_array([:service, :route, :consumer, :global]) }
  end

  describe '#formats' do
    it { expect(subject.formats).to match_array([:curl, :yaml, :kubernetes]) }
  end

  describe '#example' do
    context 'when there is a specific file for the page\'s version' do
      let(:page) { { 'kong_version' => '2.3.x' } }

      it 'returns the example defined in app/_hub/kong-inc/jwt-signer/examples/complex-example/_2.3.x.yml' do
        expect(File).to receive(:read).with('spec/fixtures/app/_hub/kong-inc/jwt-signer/examples/complex-example/_2.3.x.yml').and_call_original
        expect(subject.example).to eq({ 'name' => 'jwt-signer', 'config' => { 'access_token_introspection_scopes_claim' => ['scope', 'realm_access'] } })
      end
    end

    context 'when there isn\'t one' do
      it 'returns the example defined in app/_hub/kong-inc/jwt-signer/examples/complex-example/_index.yml' do
        expect(File).to receive(:read).with('spec/fixtures/app/_hub/kong-inc/jwt-signer/examples/complex-example/_index.yml').and_call_original
        expect(subject.example).to eq({ 'name' => 'jwt-signer', 'config' => { 'access_token_introspection_scopes_claim' => ['scope'] } })
      end
    end
  end

  describe 'validations' do
    context 'when one of the targets is not valid' do
      let(:config) do
        SafeYAML.load(
          <<~CONFIG
        name: jwt-signer-example
        plugin: kong-inc/jwt-signer
        example: complex-example
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
        name: jwt-signer-example
        plugin: kong-inc/jwt-signer
        example: complex-example
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
end

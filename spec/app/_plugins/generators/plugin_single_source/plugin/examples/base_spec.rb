RSpec.describe PluginSingleSource::Plugin::Examples::Base do
  let(:version) { '3.1.1' }

  subject { described_class.make_for(name:, vendor:, version:) }

  describe '.make_for' do
    context 'when the vendor is kong-inc' do
      let(:vendor) { 'kong-inc' }
      let(:name) { 'acme' }

      it { expect(subject).to be_an_instance_of(PluginSingleSource::Plugin::Examples::Kong) }
    end

    context 'when the vendor is third-party' do
      let(:vendor) { 'acme' }
      let(:name) { 'kong-plugin' }

      it { expect(subject).to be_an_instance_of(PluginSingleSource::Plugin::Examples::ThirdParty) }
    end
  end

  describe '#example' do
    let(:vendor) { 'kong-inc' }
    let(:name) { 'acme' }

    it 'returns the corresponding example in yaml format' do
      expect(subject.example)
        .to eq(YAML.load(File.read('app/_src/.repos/kong-plugins/examples/acme/_3.1.x.yaml')))
    end
  end
end

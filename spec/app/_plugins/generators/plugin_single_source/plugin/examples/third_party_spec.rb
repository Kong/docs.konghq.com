RSpec.describe PluginSingleSource::Plugin::Examples::ThirdParty do
  describe '#file_path' do
    subject { described_class.new(name: 'kong-plugin', vendor: 'acme', version: '3.1.1') }

    it 'returns the path to the corresponding example file' do
      expect(subject.file_path).to eq('spec/fixtures/app/_hub/acme/kong-plugin/examples/_index.yml')
    end
  end
end

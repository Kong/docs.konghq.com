RSpec.describe PluginSingleSource::Plugin::Examples::Kong do
  describe '#file_path' do
    subject { described_class.new(name: 'acme', vendor: 'kong-inc', version: '3.1.1') }

    it 'returns the path to the corresponding example file' do
      expect(subject.file_path).to eq('app/_src/.repos/kong-plugins/examples/acme/_3.1.x.yaml')
    end
  end
end

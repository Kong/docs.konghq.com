RSpec.describe PluginSingleSource::Plugin::Examples::Kong do
  let(:name) { 'acme' }
  let(:vendor) { 'kong-inc' }
  let(:version) { '3.1.1' }

  describe '#file_path' do
    subject { described_class.new(name:, vendor:, version:) }

    it 'returns the path to the corresponding example file' do
      expect(subject.file_path).to eq('app/_src/.repos/kong-plugins/examples/acme/_3.1.x.yaml')
    end
  end
end

RSpec.describe PluginSingleSource::Plugin::Examples::Kong do
  let(:name) { 'acme' }
  let(:vendor) { 'kong-inc' }
  let(:version) { '3.1.1' }

  describe '#file_path' do
    subject { described_class.new(name:, vendor:, version:) }

    it 'returns the path to the corresponding example file' do
      expect(subject.file_path).to eq('app/_src/.repos/kong-plugins/examples/acme/_3.1.x.yaml')
    end

    context 'special case - serverless-functions' do
      let(:name) { 'post-function' }

      it 'returns the path to pre-function\'s example' do
        expect(subject.file_path).to eq('app/_src/.repos/kong-plugins/examples/pre-function/_3.1.x.yaml')
      end
    end
  end
end

RSpec.describe PluginSingleSource::Plugin::Unversioned do
  let(:dir) { [author, name].join('/') }
  let(:name) { 'kong-plugin' }
  let(:author) { 'acme' }

  subject { described_class.new(dir:, site:) }

  it_behaves_like 'a Plugin'

  describe '#extension?' do
    it { expect(subject.extension?).to eq(false) }
  end

  describe '#releases' do
    context 'kong plugins' do
      let(:name) { 'jq' }
      let(:author) { 'kong-inc' }

      it 'defaults to `1.0.0`' do
        expect(subject.releases).to eq(['1.0.0'])
      end
    end

    context 'third-party plugins' do
      it 'defaults to `latest`' do
        expect(subject.releases).to eq(['3.0.0'])
      end
    end
  end

  describe '#create_pages' do
    it 'generates pages for the plugin' do
      expect(subject.create_pages.size).to eq(4)
    end
  end
end

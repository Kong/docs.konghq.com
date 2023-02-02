RSpec.describe PluginSingleSource::Plugin::Unversioned do
  let(:dir) { [author, name].join('/') }
  let(:name) { 'kong-plugin' }
  let(:author) { 'acme' }

  subject { described_class.new(dir:, site:) }

  it_behaves_like 'a Plugin'

  describe '#extension?' do
    it { expect(subject.extension?).to eq(false) }
  end

  describe '#set_version?' do
    it { expect(subject.set_version?).to eq(false) }
  end

  describe '#releases' do
    it 'defaults to `1.0.0`' do
      expect(subject.releases).to eq(['1.0.0'])
    end
  end

  describe '#create_pages' do
    it 'generates a page for the plugin' do
      expect(PluginSingleSource::Plugin::Release)
        .to receive(:new)
        .with(site:, version: '1.0.0', is_latest: true, plugin: subject, source: '_index')
        .and_call_original

      expect(subject.create_pages.size).to eq(1)
    end
  end
end

RSpec.describe SEO::IndexEntry::HubHtmlPage do
  let(:url) { '/hub/plugins/compatibility/' }
  let(:page) { double('url' => url, 'data' => {}, 'site' => site) }
  let(:latest) do
    Jekyll::GeneratorSingleSource::Product::Edition
      .new(edition: 'gateway', site:)
      .latest_release
      .value
  end
  let(:index) { {} }

  before do
    PluginSingleSource::Generator.new.generate(site)
  end

  subject { described_class.new(page) }

  describe '#indexable?' do
    it { expect(subject.indexable?(index)).to eq(true) }
  end

  describe '#attributes' do
    it { expect(subject.attributes)
      .to eq({ 'url' => url, 'page' => page, 'version' => Utils::Version.to_version(latest) }) }
  end

  describe '#key' do
    it { expect(subject.key).to eq('/hub/plugins/compatibility/') }
  end

  describe '#process!' do
    let(:index) { {} }

    before { subject.process!(index) }

    it 'sets the page\'s canonical_url' do
      expect(page.data['canonical_url']).to eq(url)
    end
  end
end

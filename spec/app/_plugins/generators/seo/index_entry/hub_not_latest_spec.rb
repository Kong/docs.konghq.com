RSpec.describe SEO::IndexEntry::HubNotLatest do
  let(:page) { find_page_by_url('/hub/acme/jq/2.8.x.html') }
  let(:index) { {} }

  before do
    PluginSingleSource::Generator.new.generate(site)
  end

  subject { described_class.new(page) }

  describe '#indexable?' do
    it { expect(subject.indexable?(index)).to eq(false) }
  end

  describe '#process!' do
    before { subject.process!(index) }

    it 'sets the canonical url to the page' do
      expect(page.data['canonical_url']).to eq('/hub/acme/jq/')
    end

    it 'sets seo_noindex to the page' do
      expect(page.data['seo_noindex']).to eq(true)
    end
  end

  describe '#attributes' do
    it { expect(subject.attributes).to eq({ 'url' => '/hub/acme/jq/', 'page' => page }) }
  end

  describe '#key' do
    it { expect(subject.key).to eq('/hub/acme/jq/') }
  end
end

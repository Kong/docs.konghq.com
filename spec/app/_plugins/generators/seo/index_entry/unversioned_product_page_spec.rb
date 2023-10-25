RSpec.describe SEO::IndexEntry::UnversionedProductPage do
  let(:page) { find_page_by_url('/konnect/') }
  let(:index) { {} }

  before do
    PluginSingleSource::Generator.new.generate(site)
  end

  subject { described_class.new(page) }

  describe '#indexable?' do
    it { expect(subject.indexable?(index)).to eq(true) }
  end

  describe '#process!' do
    before { subject.process!(index) }

    it 'sets the canonical url to the page' do
      expect(page.data['canonical_url']).to eq "/konnect/"
    end

    it 'does not set seo_noindex to the page' do
      expect(page.data['seo_noindex']).to be_nil
    end
  end

  describe '#attributes' do
    it { expect(subject.attributes).to eq({ 'url' => '/konnect/', 'page' => page }) }
  end

  describe '#key' do
    it { expect(subject.key).to eq('/konnect/') }
  end
end

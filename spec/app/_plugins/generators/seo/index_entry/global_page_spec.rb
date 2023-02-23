RSpec.describe SEO::IndexEntry::GlobalPage do
  let(:page) { find_page_by_url('/gateway/changelog/') }
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

    it 'sets `is_latest` to true' do
      expect(page.data['is_latest']).to eq(true)
    end

    it 'does not set the canonical url to the page' do
      expect(page.data['canonical_url']).to be_nil
    end

    it 'does not set seo_noindex to the page' do
      expect(page.data['seo_noindex']).to be_nil
    end
  end

  describe '#attributes' do
    it { expect(subject.attributes).to eq({ 'url' => '/gateway/changelog/', 'page' => page, 'version' => Gem::Version.new('9999.9.9') }) }
  end

  describe '#key' do
    it { expect(subject.key).to eq('/gateway/changelog/') }
  end

  describe '#version' do
    it { expect(subject.version).to eq(Gem::Version.new('9999.9.9')) }
  end
end

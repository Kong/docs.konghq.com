RSpec.describe SEO::IndexEntry::UnprocessablePage do
  let(:page) { find_page_by_url('/deck/pre-1.7/') }
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

    it 'does not set the canonical url to the page' do
      expect(page.data['canonical_url']).to be_nil
    end

    it 'does not set seo_noindex to the page' do
      expect(page.data['seo_noindex']).to be_nil
    end
  end

  describe '#attributes' do
    it { expect(subject.attributes).to eq({}) }
  end

  describe '#key' do
    it { expect(subject.key).to eq('/deck/pre-1.7/') }
  end
end

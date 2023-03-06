RSpec.describe SEO::IndexEntry::HubIndex do
  let(:page) { find_page_by_url('/hub/') }
  let(:index) { {} }

  subject { described_class.new(page) }

  describe '#indexable?' do
    it { expect(subject.indexable?(index)).to eq(true) }
  end

  describe '#process!' do
    it 'sets the canonical url to the page' do
      subject.process!(index)

      expect(page.data['canonical_url']).to eq('/hub/')
    end
  end

  describe '#attributes' do
    it { expect(subject.attributes).to eq({ 'url' => '/hub/', 'page' => page }) }
  end

  describe '#key' do
    it { expect(subject.key).to eq('/hub/') }
  end
end

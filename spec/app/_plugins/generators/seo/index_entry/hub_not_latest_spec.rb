RSpec.describe SEO::IndexEntry::HubNotLatest do
  let(:page) { find_page_by_url('/hub/kong-inc/jq/2.8.x/') }
  let(:index) { {} }

  before do
    PluginSingleSource::Generator.new.generate(site)
  end

  subject { described_class.new(page) }

  describe '#indexable?' do
    it { expect(subject.indexable?(index)).to eq(false) }
  end

  describe '#attributes' do
    it { expect(subject.attributes).to eq({ 'url' => '/hub/kong-inc/jq/', 'page' => page }) }
  end

  describe '#key' do
    it { expect(subject.key).to eq('/hub/kong-inc/jq/') }
  end
end

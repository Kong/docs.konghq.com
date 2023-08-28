RSpec.describe SEO::IndexEntry::HubLatest do
  let(:page) { find_page_by_url('/hub/acme/kong-plugin/overview/') }
  let(:index) { {} }

  before do
    PluginSingleSource::Generator.new.generate(site)
  end

  subject { described_class.new(page) }

  describe '#indexable?' do
    it { expect(subject.indexable?(index)).to eq(true) }
  end

  describe '#attributes' do
    it { expect(subject.attributes).to eq({ 'url' => '/hub/acme/kong-plugin/overview/', 'page' => page }) }
  end

  describe '#key' do
    it { expect(subject.key).to eq('/hub/acme/kong-plugin/overview/') }
  end
end

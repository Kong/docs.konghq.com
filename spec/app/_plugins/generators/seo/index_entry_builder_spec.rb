RSpec.describe SEO::IndexEntryBuilder do
  before { generate_site! }

  describe '.for' do
    let(:page) { find_page_by_url(page_url) }

    subject { described_class.for(page) }

    context 'plugin page' do
      let(:page_url) { '/hub/kong-inc/jq/' }

      it { expect(subject).to be_a(SEO::IndexEntry::HubPage) }
    end

    context 'plugin index page' do
      let(:page_url) { '/hub/' }

      it { expect(subject).to be_a(SEO::IndexEntry::HubPage) }
    end

    context 'page belonging to a product that is not versioned' do
      let(:page_url) { '/getting-started-guide/2.1.x/overview/' }

      it { expect(subject).to be_a(SEO::IndexEntry::UnversionedProductPage) }
    end

    context 'page belonging to a product that is versioned' do
      context 'global page' do
        let(:page_url) { '/gateway/changelog/' }

        it { expect(subject).to be_a(SEO::IndexEntry::GlobalPage) }
      end

      context 'versioned page' do
        let(:page_url) { '/mesh/1.6.x/' }

        it { expect(subject).to be_a(SEO::IndexEntry::VersionedPage) }
      end

      context 'latest page' do
        let(:page_url) { '/mesh/latest/' }

        it { expect(subject).to be_a(SEO::IndexEntry::VersionedPage) }
      end

      context 'else' do
        let(:page_url) { '/enterprise/references/' }

        it { expect(subject).to be_a(SEO::IndexEntry::UnprocessablePage) }
      end
    end
  end
end

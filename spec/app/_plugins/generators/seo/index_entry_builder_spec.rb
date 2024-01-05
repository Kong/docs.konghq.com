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

    context 'non single-sourced plugin page' do
      let(:page) { double('url' => '/hub/plugins/compatibility/', 'path' => '') }

      it { expect(subject).to be_a(SEO::IndexEntry::HubHtmlPage) }
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
    end

    context 'OpenAPI pages' do
      context 'konnect' do
        let(:page_url) { '/konnect/api/portal-rbac/latest/' }

        it { expect(subject).to be_a(SEO::IndexEntry::OasPage) }
      end

      context 'gateway' do
        let(:page_url) { '/gateway/api/admin-ee/latest/' }

        it { expect(subject).to be_a(SEO::IndexEntry::OasPage) }
      end
    end

    context 'assets' do
      let(:page) { double(url: '/assets/mesh/2.4.x/raw/crds/kuma.io_virtualoutbounds.yaml') }

      it { expect(subject).to be_a(SEO::IndexEntry::UnprocessablePage) }
    end
  end
end

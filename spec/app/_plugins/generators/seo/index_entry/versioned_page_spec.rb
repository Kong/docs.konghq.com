RSpec.describe SEO::IndexEntry::VersionedPage do
  let(:page) { find_page_by_url('/konnect/') }
  let(:index) { {} }

  before do
    Jekyll::GeneratorSingleSource::Generator.new.generate(site)
    PluginSingleSource::Generator.new.generate(site)
    Jekyll::Versions.new.generate(site)
    LatestVersion::Generator.new.generate(site)
  end

  subject { described_class.new(page) }

  shared_examples_for 'sets `seo_noindex` to true' do
    it { expect(page.data['seo_noindex']).to eq(true) }
  end

  shared_examples_for 'does not set `seo_noindex`' do
    it { expect(page.data['seo_noindex']).to be_nil }
  end

  shared_examples_for 'does not set `canonical_url`' do
    it { expect(page.data['canonical_url']).to be_nil }
  end

  describe '#indexable?' do
    context 'page with more than one version' do
      context 'when the page is the latest version' do
        let(:page) { find_page_by_url('/mesh/latest/') }

        it { expect(subject.indexable?(index)).to eq(true) }
      end

      context 'when the page is not the latest version' do
        context 'when the page is not in the index' do
          let(:page) { find_page_by_url('/mesh/2.0.x/') }

          it { expect(subject.indexable?(index)).to eq(true) }
        end

        context 'when the page is in the index, but the indexed version is older' do
          let(:page) { find_page_by_url('/mesh/2.0.x/') }
          let(:older_version) { find_page_by_url('/mesh/1.6.x/') }
          let(:index) do
            { '/mesh/VERSION/' => { 'version' => '1.6.0', 'page' => older_version, 'url' => older_version.url } }
          end

          it { expect(subject.indexable?(index)).to eq(true) }
        end

        context 'when the page is in the index, but the indexed version is newer' do
          let(:page) { find_page_by_url('/mesh/1.6.x/') }
          let(:newer_version) { find_page_by_url('/mesh/2.0.x/') }
          let(:index) do
            { '/mesh/VERSION/' => { 'version' => '2.0.0', 'page' => newer_version, 'url' => newer_version.url } }
          end

          it { expect(subject.indexable?(index)).to eq(false) }
        end
      end
    end
  end

  describe '#process!' do
    let(:index) { SEO::Index.generate(site) }

    before { subject.process!(index) }

    context 'current endpoints' do
      context 'when the page is the latest version' do
        let(:page) { find_page_by_url('/mesh/latest/') }

        it 'sets the `canonical_url`' do
          expect(page.data['canonical_url']).to eq('/mesh/latest/')
        end

        it_behaves_like 'does not set `seo_noindex`'
      end

      context 'when the page is not the latest version' do
        let(:page) { find_page_by_url('/mesh/1.6.x/') }

        it 'sets the `canonical_url`' do
          expect(page.data['canonical_url']).to eq('/mesh/latest/')
        end

        it_behaves_like 'sets `seo_noindex` to true'
      end
    end

    context 'legacy endpoints and moved urls require extra checks' do
      context 'moved urls' do
        let(:page) { find_page_by_url('/gateway-oss/2.1.x/configuration/') }

        it_behaves_like 'sets `seo_noindex` to true'

        it 'sets the `canonical_url`' do
          expect(page.data['canonical_url']).to eq('/gateway/latest/reference/configuration/')
        end

        # TODO: test circular references
      end

      context 'legacy endpoints - also checks for urls under `/gateway/VERSION/path/`' do
        context 'gateway-oss' do
          let(:page) { find_page_by_url('/gateway-oss/2.1.x/') }

          it_behaves_like 'sets `seo_noindex` to true'

          it 'sets the `canonical_url`' do
            expect(page.data['canonical_url']).to eq('/gateway/latest/')
          end
        end

        context 'enterprise' do
          let(:page) { find_page_by_url('/enterprise/2.1.x/') }

          it_behaves_like 'sets `seo_noindex` to true'

          it 'sets the `canonical_url`' do
            expect(page.data['canonical_url']).to eq('/gateway/latest/')
          end
        end
      end
    end
  end

  describe '#attributes' do
    let(:page) { find_page_by_url('/mesh/latest/') }

    it { expect(subject.attributes).to eq({ 'url' => '/mesh/latest/', 'page' => page, 'version' => Gem::Version.new('9999.9.9') }) }
  end

  describe '#key' do
    let(:page) { find_page_by_url('/mesh/latest/') }

    it { expect(subject.url).to eq('/mesh/VERSION/') }
  end

  describe '#version' do
    context 'when it is the latest version of the page' do
      let(:page) { find_page_by_url('/mesh/latest/') }

      it 'sets its version to 9999.9.9' do
        expect(subject.version).to eq(Gem::Version.new('9999.9.9'))
      end
    end

    context 'when it is not' do
      let(:page) { find_page_by_url('/mesh/1.6.x/') }

      it 'extracts the version from the url and replaces `x` with `0`' do
        expect(subject.version).to eq(Gem::Version.new('1.6.0'))
      end
    end
  end

  describe '#url' do
    context 'when the url is under /gateway-oss/ or /enterprise/ - which can never be canonical' do
      context 'gateway-oss' do
        let(:page) { find_page_by_url('/gateway-oss/2.1.x/') }

        it 'replaces `gateway-oss` with `gateway` and the version with a placeholder' do
          expect(subject.url).to eq('/gateway/VERSION/')
        end
      end

      context 'enterprise' do
        let(:page) { find_page_by_url('/enterprise/2.1.x/') }

        it 'replaces `enterprise` with `gateway` and the version with a placeholder' do
          expect(subject.url).to eq('/gateway/VERSION/')
        end
      end
    end

    context 'otherwise' do
      let(:page) { find_page_by_url('/mesh/latest/') }

      it 'replaces the version with a placeholder' do
        expect(subject.url).to eq('/mesh/VERSION/')
      end
    end
  end
end

RSpec.describe LatestVersion::Generator do
  shared_examples_for 'does not create a latest page' do
    it { expect{ subject }.not_to change { site.pages.size } }
  end

  shared_examples_for 'creates a latest page' do
    it { expect{ subject }.to change { site.pages.size }.by(1) }
  end

  before do
    Jekyll::Versions.new.generate(site)
    Jekyll::GeneratorSingleSource::Generator.new.generate(site)
  end

  describe '#generate' do
    subject { described_class.new.generate(site) }

    before do
      allow(site).to receive(:pages).and_call_original
      allow(site).to receive(:pages).and_return([page])
    end

    context 'products without latest' do
      let(:page) { find_page_by_url('/mesh/changelog/') }

      it { expect{ subject }.not_to change { site.pages.size } }
    end

    context 'products with latest' do
      context 'when the page is not the latest version' do
        let(:page) { find_page_by_url('/mesh/1.6.x/') }

        it_behaves_like 'does not create a latest page'
      end

      context 'when the page has a permalink set' do
        let(:page) { find_page_by_url('/mesh/2.1.x/') }

        before { page.data['permalink'] = '/mesh/' }

        it_behaves_like 'does not create a latest page'
      end

      context 'when the page is marked as `is_latest`' do
        let(:page) { find_page_by_url('/mesh/2.1.x/') }

        before { page.data['is_latest'] = true }

        it_behaves_like 'does not create a latest page'
      end

      context 'when the page is the latest version' do
        let(:page) { find_page_by_url('/mesh/2.1.x/') }

        it_behaves_like 'creates a latest page'

        it 'creates a `latest` page' do
          subject

          latest = site.pages.last

          expect(latest.name).to eq('index.md')
          expect(latest.dir).to eq('/mesh/latest/')
          expect(latest.data['is_latest']).to eq(true)
          expect(latest.data['version-index']).to be_nil
          expect(latest.data['edit-link']).to be_nil
          expect(latest.data['alias']).to eq(['/mesh/'])
          expect(latest.relative_path).to eq('_src/mesh/index.md')
          expect(latest.content).to eq(page.content)
        end

        context 'gateway' do
          let(:page) { find_page_by_url('/gateway/3.0.x/') }

          it_behaves_like 'creates a latest page'
        end

        context 'kic' do
          let(:page) { find_page_by_url('/kubernetes-ingress-controller/2.7.x/') }

          it_behaves_like 'creates a latest page'
        end

        context 'deck' do
          let(:page) { find_page_by_url('/deck/1.16.x/') }

          it_behaves_like 'creates a latest page'
        end

        context 'pages that do not belong to products with latest versions' do
          ['/404.html', '/contributing/'].each do |p|
            let(:page) { find_page_by_url(p) }

            it_behaves_like 'does not create a latest page'
          end
        end
      end
    end
  end
end

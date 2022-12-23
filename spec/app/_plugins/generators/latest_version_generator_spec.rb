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

  let(:page) { site.pages.detect { |p| p.relative_path == relative_path } }

  describe '#generate' do
    subject { described_class.new.generate(site) }

    before do
      allow(site).to receive(:pages).and_call_original
      allow(site).to receive(:pages).and_return([page])
    end

    context 'products without latest' do
      let(:relative_path) { 'mesh/changelog.md' }

      it { expect{ subject }.not_to change { site.pages.size } }
    end

    context 'products with latest' do
      context 'when the page is not the latest version' do
        let(:relative_path) { 'mesh/1.6.x/index.md' }

        it_behaves_like 'does not create a latest page'
      end

      context 'when the page has a permalink set' do
        let(:relative_path) { 'mesh/2.0.x/index.md' }

        before { page.data['permalink'] = '/mesh/' }

        it_behaves_like 'does not create a latest page'
      end

      context 'when the page is marked as `is_latest`' do
        let(:relative_path) { 'mesh/2.0.x/index.md' }

        before { page.data['is_latest'] = true }

        it_behaves_like 'does not create a latest page'
      end

      context 'when the page is the latest version' do
        let(:relative_path) { 'mesh/2.0.x/index.md' }

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
          expect(latest.relative_path).to eq('mesh/2.0.x/index.md')
          expect(latest.content).to eq(page.content)
        end

        context 'gateway' do
          let(:relative_path) { '_src/gateway/index.md' }

          it_behaves_like 'creates a latest page'
        end

        context 'kic' do
          let(:relative_path) { '_src/kubernetes-ingress-controller/index.md' }

          it_behaves_like 'creates a latest page'
        end

        context 'deck' do
          let(:relative_path) { '_src/deck/index.md' }

          it_behaves_like 'creates a latest page'
        end

        context 'pages that do not belong to products with latest versions' do
          ['404.html', 'gateway-oss/2.1.x/index.md', 'contributing/index.md', 'enterprise/k8s-changelog.md'].each do |path|
            let(:relative_path) { path }

            it_behaves_like 'does not create a latest page'
          end
        end
      end
    end
  end
end

RSpec.describe ProductsRenderer do
  describe '#render?' do
    subject { described_class.new }

    shared_examples_for 'always render home' do
      it_behaves_like 'renders the page', '/'
    end

    shared_examples_for 'renders the page' do |page_dir|
      it { expect(subject.render?(double(dir: page_dir))).to eq(true) }
    end

    shared_examples_for 'does not render the page' do |page_dir|
      it { expect(subject.render?(double(dir: page_dir))).to eq(false) }
    end

    context 'plugin hub' do
      before do
        allow(ENV).to receive(:fetch).with('KONG_PRODUCTS', '').and_return('hub')
      end

      it_behaves_like 'always render home'

      context 'only renders hub pages' do
        ['/hub/', '/hub/kong-inc/tcp-log/'].each do |page_dir|
          it_behaves_like 'renders the page', page_dir
        end

        ['/gateway/', '/konnect/'].each do |page_dir|
          it_behaves_like 'does not render the page', page_dir
        end
      end
    end

    context 'specifying a product with multiple versions' do
      before do
        allow(ENV).to receive(:fetch).with('KONG_PRODUCTS', '').and_return('gateway:2.8.x;3.3.x;latest')
      end

      it_behaves_like 'always render home'

      [
        '/gateway/latest/', '/gateway/3.3.x/', '/gateway/2.8.x/',
        '/gateway/latest/admin-api/', '/gateway/3.3.x/admin-api/', '/gateway/2.8.x/admin-api/'
      ].each do |page_dir|
        it_behaves_like 'renders the page', page_dir
      end

      ['/hub/', '/konnect/', '/gateway/2.7.x/'].each do |page_dir|
        it_behaves_like 'does not render the page', page_dir
      end
    end

    context 'specifying multiple products with multiple versions' do
      before do
        allow(ENV).to receive(:fetch).with('KONG_PRODUCTS', '').and_return('gateway:2.8.x;3.3.x;latest,mesh:latest;2.2.x')
      end

      it_behaves_like 'always render home'

      [
        '/gateway/latest/', '/gateway/3.3.x/', '/gateway/2.8.x/',
        '/mesh/latest/', '/mesh/2.2.x/', '/mesh/latest/features/', '/mesh/2.2.x/features',
        '/gateway/latest/admin-api/', '/gateway/3.3.x/admin-api/', '/gateway/2.8.x/admin-api/'
      ].each do |page_dir|
        it_behaves_like 'renders the page', page_dir
      end

      ['/hub/', '/konnect/', '/gateway/2.7.x/', '/mesh/2.1.x/'].each do |page_dir|
        it_behaves_like 'does not render the page', page_dir
      end
    end

    context 'wildcard matching' do
      context 'versions wildcard' do
        before do
          allow(ENV).to receive(:fetch).with('KONG_PRODUCTS', '').and_return('gateway:3.*')
        end

        [
          '/gateway/3.0.x/', '/gateway/3.1.x/', '/gateway/3.2.x/',
          '/gateway/3.0.x/stability/', '/gateway/3.1.x/stability/', '/gateway/3.2.x/stability/',
        ].each do |page_dir|
          it_behaves_like 'renders the page', page_dir
        end

          [
            '/gateway/1.8.x/', '/gateway/2.8.x/',
            '/gateway/1.8.x/stability/', '/gateway/2.8.x/stability/',
            '/hub/', '/deck/', '/konnect/'
          ].each do |page_dir|
            it_behaves_like 'does not render the page', page_dir
          end
      end

      context 'products wildcard' do
        before do
          allow(ENV).to receive(:fetch).with('KONG_PRODUCTS', '').and_return('*:latest')
        end

        it_behaves_like 'always render home'

        context 'renders all the latest versions of the products' do
          [
            '/gateway/latest/', '/mesh/latest/', '/mesh/latest/features/', '/gateway/latest/admin-api/',
            '/deck/latest/', '/deck/latest/terminology/',
            '/kubernetes-ingress-controller/latest/', '/kubernetes-ingress-controller/latest/faq/'
          ].each do |page_dir|
            it_behaves_like 'renders the page', page_dir
          end
        end

        [
          '/hub/', '/gateway/2.7.x/', '/mesh/2.1.x/',
          '/deck/1.23.x/', '/kubernetes-ingress-controller/2.9.x/',
          '/konnect/', '/konnect/architecture/'
        ].each do |page_dir|
          it_behaves_like 'does not render the page', page_dir
        end
      end
    end
  end
end

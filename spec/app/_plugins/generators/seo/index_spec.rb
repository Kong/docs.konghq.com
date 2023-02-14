RSpec.describe SEO::Index do
  describe '.generate' do
    before { generate_site! }

    subject { described_class.generate(site) }

    it 'generates an index with the latest version of each page' do
      expect(subject).to eq({
        '/hub/' => { 'url' => '/hub/', 'page' => find_page_by_url('/hub/') },
        '/hub/acme/jq/' => { 'url' => '/hub/acme/jq/', 'page' => find_page_by_url('/hub/acme/jq/') },
        '/hub/acme/jq/changelog/' => { 'url' => '/hub/acme/jq/changelog/', 'page' => find_page_by_url('/hub/acme/jq/changelog/') },
        '/hub/acme/jq/how-to/' => { 'url' => '/hub/acme/jq/how-to/', 'page' => find_page_by_url('/hub/acme/jq/how-to/') },
        '/hub/acme/jwt-signer/' => { 'url' => '/hub/acme/jwt-signer/', 'page' => find_page_by_url('/hub/acme/jwt-signer/') },
        '/hub/acme/jwt-signer/changelog/' => { 'url' => '/hub/acme/jwt-signer/changelog/', 'page' => find_page_by_url('/hub/acme/jwt-signer/changelog/') },
        '/hub/acme/jwt-signer/how-to/' => { 'url' => '/hub/acme/jwt-signer/how-to/', 'page' => find_page_by_url('/hub/acme/jwt-signer/how-to/') },
        '/hub/acme/jwt-signer/how-to/nested/tutorial/' => { 'url' => '/hub/acme/jwt-signer/how-to/nested/tutorial/', 'page' => find_page_by_url('/hub/acme/jwt-signer/how-to/nested/tutorial/') },
        '/hub/acme/jwt-signer/reference/' => { 'url' => '/hub/acme/jwt-signer/reference/', 'page' => find_page_by_url('/hub/acme/jwt-signer/reference/') },
        '/hub/acme/jwt-signer/reference/api/' => { 'url' => '/hub/acme/jwt-signer/reference/api/', 'page' => find_page_by_url('/hub/acme/jwt-signer/reference/api/') },
        '/hub/acme/kong-plugin/' => { 'url' => '/hub/acme/kong-plugin/', 'page' => find_page_by_url('/hub/acme/kong-plugin/') },
        '/hub/acme/kong-plugin/changelog/' => { 'url' => '/hub/acme/kong-plugin/changelog/', 'page' => find_page_by_url('/hub/acme/kong-plugin/changelog/') },
        '/hub/acme/kong-plugin/how-to/' => { 'url' => '/hub/acme/kong-plugin/how-to/', 'page' => find_page_by_url('/hub/acme/kong-plugin/how-to/') },
        '/hub/acme/unbundled-plugin/' => { 'url' => '/hub/acme/unbundled-plugin/', 'page' => find_page_by_url('/hub/acme/unbundled-plugin/') },
        '/hub/acme/unbundled-plugin/changelog/' => { 'url' => '/hub/acme/unbundled-plugin/changelog/', 'page' => find_page_by_url('/hub/acme/unbundled-plugin/changelog/') },
        '/hub/acme/unbundled-plugin/how-to/' => { 'url' => '/hub/acme/unbundled-plugin/how-to/', 'page' => find_page_by_url('/hub/acme/unbundled-plugin/how-to/') },

        '/' => { 'url' => '/', 'page' => find_page_by_url('/') },
        '/kuma-to-kong-mesh/' => { 'url' => '/kuma-to-kong-mesh/', 'page' => find_page_by_url('/kuma-to-kong-mesh/') },
        '/404.html' => { 'url' => '/404.html', 'page' => find_page_by_url('/404.html') },
        '/moved_urls.yml' => { 'url' => '/moved_urls.yml', 'page' => find_page_by_url('/moved_urls.yml') },

        '/contributing/' => { 'url' => '/contributing/', 'page' => find_page_by_url('/contributing/') },
        '/deck/VERSION/' => { 'url' => '/deck/latest/', 'page' => find_page_by_url('/deck/latest/'), 'version' => Gem::Version.new('9999.9.9') },
        '/gateway/VERSION/' => { 'url' => '/gateway/latest/', 'page' => find_page_by_url('/gateway/latest/'), 'version' => Gem::Version.new('9999.9.9') },
        '/gateway/changelog/' => { 'url' => '/gateway/changelog/', 'page' => find_page_by_url('/gateway/changelog/'), 'version' => Gem::Version.new('9999.9.9') },

        '/gateway/VERSION/reference/configuration/' => { 'url' => '/gateway/latest/reference/configuration/', 'page' => find_page_by_url('/gateway/latest/reference/configuration/'), 'version' => Gem::Version.new('9999.9.9') },
        '/gateway/VERSION/configuration/' => { 'url' => '/gateway-oss/2.1.x/configuration/', 'page' => find_page_by_url('/gateway-oss/2.1.x/configuration/'), 'version' => Gem::Version.new('2.1.0') },
        '/getting-started-guide/2.1.x/overview/' => { 'url' => '/getting-started-guide/2.1.x/overview/', 'page' => find_page_by_url('/getting-started-guide/2.1.x/overview/') },

        '/konnect/' => { 'url' => '/konnect/', 'page' => find_page_by_url('/konnect/') },

        '/kubernetes-ingress-controller/VERSION/' => { 'url' => '/kubernetes-ingress-controller/latest/', 'page' => find_page_by_url('/kubernetes-ingress-controller/latest/'), 'version' => Gem::Version.new('9999.9.9') },

        '/mesh/VERSION/' => { 'url' => '/mesh/latest/', 'page' => find_page_by_url('/mesh/latest/'), 'version' => Gem::Version.new('9999.9.9') },
        '/mesh/changelog/' => { 'url' => '/mesh/changelog/', 'page' => find_page_by_url('/mesh/changelog/'), 'version' => Gem::Version.new('9999.9.9') },
      })
    end

    it 'excludes global pages and the ones that do not have versions' do
      expect(subject['/enterprise/references/']).to be_nil
      expect(subject['/enterprise/k8s-changelog/']).to be_nil
      expect(subject['/enterprise/VERSION/']).to be_nil
    end
  end
end

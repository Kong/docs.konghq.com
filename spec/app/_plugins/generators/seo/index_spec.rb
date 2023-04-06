RSpec.describe SEO::Index do
  describe '.generate' do
    before { generate_site! }

    subject { described_class.generate(site) }

    it 'generates an index with the latest version of each page' do
      expect(subject).to eq({
        '/hub/' => { 'url' => '/hub/', 'page' => find_page_by_url('/hub/') },
        '/hub/kong-inc/jq/' => { 'url' => '/hub/kong-inc/jq/', 'page' => find_page_by_url('/hub/kong-inc/jq/') },
        '/hub/kong-inc/jq/changelog/' => { 'url' => '/hub/kong-inc/jq/changelog/', 'page' => find_page_by_url('/hub/kong-inc/jq/changelog/') },
        '/hub/kong-inc/jq/reference/' => { 'url' => '/hub/kong-inc/jq/reference/', 'page' => find_page_by_url('/hub/kong-inc/jq/reference/') },
        '/hub/kong-inc/jq/how-to/' => { 'url' => '/hub/kong-inc/jq/how-to/', 'page' => find_page_by_url('/hub/kong-inc/jq/how-to/') },
        '/hub/kong-inc/jwt-signer/' => { 'url' => '/hub/kong-inc/jwt-signer/', 'page' => find_page_by_url('/hub/kong-inc/jwt-signer/') },
        '/hub/kong-inc/jwt-signer/changelog/' => { 'url' => '/hub/kong-inc/jwt-signer/changelog/', 'page' => find_page_by_url('/hub/kong-inc/jwt-signer/changelog/') },
        '/hub/kong-inc/jwt-signer/how-to/' => { 'url' => '/hub/kong-inc/jwt-signer/how-to/', 'page' => find_page_by_url('/hub/kong-inc/jwt-signer/how-to/') },
        '/hub/kong-inc/jwt-signer/how-to/nested/tutorial/' => { 'url' => '/hub/kong-inc/jwt-signer/how-to/nested/tutorial/', 'page' => find_page_by_url('/hub/kong-inc/jwt-signer/how-to/nested/tutorial/') },
        '/hub/kong-inc/jwt-signer/reference/' => { 'url' => '/hub/kong-inc/jwt-signer/reference/', 'page' => find_page_by_url('/hub/kong-inc/jwt-signer/reference/') },
        '/hub/acme/kong-plugin/' => { 'url' => '/hub/acme/kong-plugin/', 'page' => find_page_by_url('/hub/acme/kong-plugin/') },
        '/hub/acme/kong-plugin/changelog/' => { 'url' => '/hub/acme/kong-plugin/changelog/', 'page' => find_page_by_url('/hub/acme/kong-plugin/changelog/') },
        '/hub/acme/kong-plugin/how-to/' => { 'url' => '/hub/acme/kong-plugin/how-to/', 'page' => find_page_by_url('/hub/acme/kong-plugin/how-to/') },
        '/hub/acme/kong-plugin/reference/' => { 'url' => '/hub/acme/kong-plugin/reference/', 'page' => find_page_by_url('/hub/acme/kong-plugin/reference/') },
        '/hub/acme/unbundled-plugin/' => { 'url' => '/hub/acme/unbundled-plugin/', 'page' => find_page_by_url('/hub/acme/unbundled-plugin/') },
        '/hub/acme/unbundled-plugin/changelog/' => { 'url' => '/hub/acme/unbundled-plugin/changelog/', 'page' => find_page_by_url('/hub/acme/unbundled-plugin/changelog/') },
        '/hub/acme/unbundled-plugin/how-to/' => { 'url' => '/hub/acme/unbundled-plugin/how-to/', 'page' => find_page_by_url('/hub/acme/unbundled-plugin/how-to/') },
        '/hub/acme/unbundled-plugin/reference/' => { 'url' => '/hub/acme/unbundled-plugin/reference/', 'page' => find_page_by_url('/hub/acme/unbundled-plugin/reference/') },

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

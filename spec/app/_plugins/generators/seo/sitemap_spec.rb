RSpec.describe SEO::Sitemap do
  describe '.generate' do
    before do
      generate_site!
      index.generate
    end

    let(:index) { SEO::Index.new(site) }

    subject { described_class.generate(index) }

    it 'sets the corresponding SEO attributes to every page' do
      index.entries.each do |entry|
        expect(entry).to receive(:process!)
      end

      subject
    end

    it 'generates the sitemap' do
      expect(subject).to match_array([
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/mesh/changelog/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/gateway/changelog/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/contributing/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/kubernetes-ingress-controller/latest/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/kubernetes-ingress-controller/latest/introduction/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/mesh/latest/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/gateway/latest/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/konnect/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/kuma-to-kong-mesh/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/deck/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/gateway/latest/reference/configuration/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/kong-inc/jq/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/kong-inc/jq/changelog/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/kong-inc/jq/how-to/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/kong-inc/jq/configuration/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/kong-inc/jq/how-to/basic-example/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/kong-inc/jwt-signer/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/kong-inc/jwt-signer/nested/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/kong-inc/jwt-signer/changelog/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/kong-inc/jwt-signer/how-to/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/kong-inc/jwt-signer/how-to/nested/tutorial/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/kong-inc/jwt-signer/how-to/nested/tutorial-with-min-and-max/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/kong-inc/jwt-signer/configuration/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/kong-inc/jwt-signer/how-to/basic-example/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/acme/kong-plugin/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/acme/kong-plugin/configuration/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/acme/kong-plugin/how-to/basic-example/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/acme/kong-plugin/how-to/local-testing/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/acme/unbundled-plugin/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/acme/unbundled-plugin/changelog/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/hub/acme/unbundled-plugin/configuration/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/konnect/api/portal-rbac/latest/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/konnect/api/audit-logs/latest/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/gateway/api/admin-ee/latest/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/api/' },
        { 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => '/search/' }
      ])
    end

    it 'excludes a predefined list of pages' do
      described_class::EXCLUDED.each do |url|
        expect(subject).not_to include({ 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => url })
      end
    end

    it 'excludes pages marked with `seo_noindex`' do
      excluded_page = find_page_by_url('/hub/kong-inc/jwt-signer/2.7.x/')
      expect(subject).not_to include({ 'changefreq' => 'weekly', 'priority' => '1.0', 'url' => excluded_page.url })
      expect(excluded_page.data['seo_noindex']).to eq(true)
    end
  end
end

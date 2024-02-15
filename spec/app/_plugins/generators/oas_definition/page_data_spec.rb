RSpec.describe OasDefinition::PageData do
  let(:file) { '_api/konnect/audit-logs/_index.md' }
  let(:product) do
    JSON.parse(
      File.read('spec/fixtures/app/_data/konnect_oas_data.json')
    ).detect{ |p| p['id'] == 'e46e7742-befb-49b1-9bf1-7cbe477ab818' }
  end

  describe '#build_data' do
    subject { described_class.new(product:, version:, file:, site:, latest:).build_data }

    context 'latest version' do
      let(:latest) { true }
      let(:version) do
        product['versions'].detect { |v| v['name'] == 'v2' }
      end

      it 'generates the necessary page data' do
        expect(subject['source_file']).to eq(file)
        expect(subject['dir']).to eq('/konnect/api/audit-logs/latest/')
        expect(subject['product']['id']).to eq('e46e7742-befb-49b1-9bf1-7cbe477ab818')
        expect(subject['permalink']).to eq('/konnect/api/audit-logs/latest/')
        expect(subject['description']).to eq('The management API for Konnect audit logging')
        expect(subject['title']).to eq('Audit Logs API')
        expect(subject['version']).to eq({ 'name' => 'v2', 'id' => 'd36126ee-ab8d-47b2-960f-5703da22cced' })
        expect(subject['layout']).to eq('oas/spec')
        expect(subject['canonical_url']).to eq('/konnect/api/audit-logs/latest/')
        expect(subject['is_latest']).to eq(true)
        expect(subject['algolia_docsearch_meta']).to match_array([
          { 'name' => 'docsearch:title', 'value' => 'Audit Logs API - latest' },
          { 'name' => 'docsearch:description', 'value' => 'The management API for Konnect audit logging' }
        ])
      end
    end

    context 'specific version' do
      let(:latest) { false }
      let(:version) do
        product['versions'].detect { |v| v['name'] == 'v1' }
      end

      it 'generates the necessary page data' do
        expect(subject['source_file']).to eq(file)
        expect(subject['dir']).to eq('/konnect/api/audit-logs/v1/')
        expect(subject['product']['id']).to eq('e46e7742-befb-49b1-9bf1-7cbe477ab818')
        expect(subject['permalink']).to eq('/konnect/api/audit-logs/v1/')
        expect(subject['description']).to eq('The management API for Konnect audit logging')
        expect(subject['title']).to eq('Audit Logs API')
        expect(subject['version']).to eq({ 'name' => 'v1', 'id' => 'd36126ee-ab8d-47b2-960f-5703da22ccee' })
        expect(subject['layout']).to eq('oas/spec')
        expect(subject['canonical_url']).to eq('/konnect/api/audit-logs/latest/')
        expect(subject['is_latest']).to eq(false)
        expect(subject['algolia_docsearch_meta']).to match_array([
          { 'name' => 'docsearch:title', 'value' => 'Audit Logs API - v1' },
          { 'name' => 'docsearch:description', 'value' => 'The management API for Konnect audit logging' }
        ])
      end
    end

    context 'page with data in frontmatter' do
      let(:latest) { true }
      let(:file) { '_api/konnect/portal-rbac/_index.md' }
      let(:product) do
        JSON.parse(
          File.read('spec/fixtures/app/_data/konnect_oas_data.json')
        ).detect{ |p| p['id'] == '2dad627f-7269-40db-ab14-01264379cec7' }
      end
      let(:version) do
        product['versions'].detect { |v| v['name'] == 'v2' }
      end

      it 'generates the necessary page data, including the frontmatter' do
        expect(subject['source_file']).to eq(file)
        expect(subject['dir']).to eq('/konnect/api/portal-rbac/latest/')
        expect(subject['product']['id']).to eq('2dad627f-7269-40db-ab14-01264379cec7')
        expect(subject['permalink']).to eq('/konnect/api/portal-rbac/latest/')
        expect(subject['description']).to eq('Custom description in Frontmatter')
        expect(subject['title']).to eq('Portal RBAC')
        expect(subject['version']).to eq({ 'name' => 'v2', 'id' => '0ecb66fc-0049-414a-a1f9-f29e8a02c696' })
        expect(subject['layout']).to eq('oas/spec')
        expect(subject['canonical_url']).to eq('/konnect/api/portal-rbac/latest/')
        expect(subject['is_latest']).to eq(true)
        expect(subject['algolia_docsearch_meta']).to match_array([
          { 'name' => 'docsearch:title', 'value' => 'Portal RBAC - latest' },
          { 'name' => 'docsearch:description', 'value' => '(Konnect) The portal rbac api provides methods for creating and describing teams, collecting developers into teams, assigning roles to give those teams functionality in the developer portal.' }
        ])
      end
    end

    context 'API version that follows semver' do
      let(:latest) { false }
      let(:file) { '_api/gateway/admin-ee/_index.md' }
      let(:product) do
        JSON.parse(
          File.read('spec/fixtures/app/_data/konnect_oas_data.json')
        ).detect{ |p| p['id'] == '937dcdd7-4485-47dc-af5f-b805d562552f' }
      end
      let(:version) do
        product['versions'].detect { |v| v['name'] == '3.4.0.0' }
      end

      it 'generates the necessary page data, and replaces the version with the corresponding release in the url' do
        expect(subject['source_file']).to eq(file)
        expect(subject['dir']).to eq('/gateway/api/admin-ee/3.4.0.x/')
        expect(subject['product']['id']).to eq('937dcdd7-4485-47dc-af5f-b805d562552f')
        expect(subject['permalink']).to eq('/gateway/api/admin-ee/3.4.0.x/')
        expect(subject['description']).to eq('Kong Gateway (EE) comes with an internal RESTful API for administration purposes. This spec is a Beta version.')
        expect(subject['title']).to eq('Gateway Admin - EE (Beta)')
        expect(subject['version']).to eq({ 'name' => '3.4.0.0', 'id' => '25d728a0-cfe3-4cf4-8e90-93a5bb15cfd9' })
        expect(subject['layout']).to eq('oas/spec')
        expect(subject['canonical_url']).to eq('/gateway/api/admin-ee/latest/')
        expect(subject['is_latest']).to eq(false)
        expect(subject['algolia_docsearch_meta']).to match_array([
          { 'name' => 'docsearch:title', 'value' => 'Gateway Admin - EE (Beta) - 3.4.0.0' },
          { 'name' => 'docsearch:description', 'value' => 'Kong Gateway (EE) comes with an internal RESTful API for administration purposes. This spec is a Beta version.' }
        ])
      end
    end
  end
end

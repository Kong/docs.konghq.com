RSpec.describe OasDefinition::PageData do
  let(:file) { '_api/audit-logs/_index.md' }
  let(:product) do
    JSON.parse(
      File.read('spec/fixtures/app/_data/konnect_oas_data.json')
    ).detect{ |p| p['id'] == 'e46e7742-befb-49b1-9bf1-7cbe477ab818' }
  end

  describe '#build_data' do
    subject { described_class.new(product:, version:, file:, latest:).build_data }

    context 'latest version' do
      let(:latest) { true }
      let(:version) do
        product['versions'].detect { |v| v['name'] == 'v2' }
      end

      it 'generates the necessary page data' do
        expect(subject['source_file']).to eq(file)
        expect(subject['dir']).to eq('/api/audit-logs/latest/')
        expect(subject['product_info']).to eq({ 'id' => 'e46e7742-befb-49b1-9bf1-7cbe477ab818' })
        expect(subject['permalink']).to eq('/api/audit-logs/latest/')
        expect(subject['description']).to eq('The management API for Konnect audit logging')
        expect(subject['title']).to eq('Audit Logs API - latest')
        expect(subject['version']).to eq({ 'name' => 'v2', 'id' => 'd36126ee-ab8d-47b2-960f-5703da22cced' })
        expect(subject['layout']).to eq('oas-spec')
        expect(subject['canonical_url']).to eq('/api/audit-logs/latest/')
        expect(subject['is_latest']).to eq(true)
      end
    end

    context 'specific version' do
      let(:latest) { false }
      let(:version) do
        product['versions'].detect { |v| v['name'] == 'v1' }
      end

      it 'generates the necessary page data' do
        expect(subject['source_file']).to eq(file)
        expect(subject['dir']).to eq('/api/audit-logs/v1/')
        expect(subject['product_info']).to eq({ 'id' => 'e46e7742-befb-49b1-9bf1-7cbe477ab818' })
        expect(subject['permalink']).to eq('/api/audit-logs/v1/')
        expect(subject['description']).to eq('The management API for Konnect audit logging')
        expect(subject['title']).to eq('Audit Logs API - v1')
        expect(subject['version']).to eq({ 'name' => 'v1', 'id' => 'd36126ee-ab8d-47b2-960f-5703da22ccee' })
        expect(subject['layout']).to eq('oas-spec')
        expect(subject['canonical_url']).to eq('/api/audit-logs/latest/')
        expect(subject['is_latest']).to eq(false)
      end
    end
  end
end

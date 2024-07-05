# frozen_string_literal: true

RSpec.describe OasDefinition::Product do
  let(:file) { File.join(site.source, '_api/konnect/audit-logs/_index.md') }
  let(:product) do
    JSON.parse(
      File.read('spec/fixtures/app/_data/konnect_oas_data.json')
    ).detect { |p| p['id'] == 'e46e7742-befb-49b1-9bf1-7cbe477ab818' }
  end
  let(:frontmatter) do
    {
      'insomnia_link' => 'https://insomnia.rest/run/?label=Konnect%20Customizable%20Portal&uri=https%3A%2F%2Fraw.githubusercontent.com%2FKong%2Fdocs.konghq.com%2Fmain%2Fapi-specs%2FKonnect%2Fv2%2Fyaml%2Fportal-api.yaml'
    }
  end

  describe '#generate_pages!' do
    subject { described_class.new(site:, file:, product:, frontmatter:) }

    before do
      site.data['ssg_oas_pages'] = []
      allow(YAML).to receive(:load_file)
        .with("#{site.source}/../api-specs/Konnect/v2/yaml/portal-api.yaml")
        .and_return(
          {
            'x-errors' => {
              'granted-scopes-unavailable' => {
                'description' => 'Sample description',
                'resolution' => 'Sample resolution'
              }
            }
          }
        )
    end

    it 'generates a page for each version of the product' do
      subject.generate_pages!

      permalinks = site.pages.map(&:permalink)
      expect(permalinks).to include('/konnect/api/audit-logs/v1/')
      expect(permalinks).to include('/konnect/api/audit-logs/v2/')
    end

    it 'generates a latest page' do
      subject.generate_pages!

      expect(site.pages.map(&:permalink)).to include('/konnect/api/audit-logs/latest/')
    end

    it 'generates an error page' do
      subject.generate_pages!

      expect(site.pages.map(&:permalink)).to include('/konnect/api/audit-logs/latest/errors/')
    end
  end
end

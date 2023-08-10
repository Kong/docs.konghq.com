RSpec.describe OasDefinition::Product do
  let(:file) { File.join(site.source, '_api/konnect/audit-logs/_index.md') }
  let(:product) do
    JSON.parse(
      File.read('spec/fixtures/app/_data/konnect_oas_data.json')
    ).detect{ |p| p['id'] == 'e46e7742-befb-49b1-9bf1-7cbe477ab818' }
  end

  describe '#generate_pages!' do
    subject { described_class.new(site:, file:, product:) }

    before { site.data['ssg_oas_pages'] = [] }

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
  end
end

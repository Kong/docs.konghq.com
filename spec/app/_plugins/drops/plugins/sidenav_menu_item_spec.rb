RSpec.describe Jekyll::Drops::SidenavMenuItem do
  let(:options) do
    {
      'docs_url' => 'gateway',
      'version' => '3.2.x'
    }
  end

  subject { described_class.new(item:, options:)}

  describe '#url' do
    context 'when the url is absolute' do
      let(:item) do
        {
          'text' => 'Portal API Documentation',
          'url' => 'https://developer.konghq.com/spec/3e65edbc-364d-4762-9d3e-f13083e1b534/33cd4595-e389-4c2b-80ee-5275f25e80e1',
          'absolute_url' => true
        }
      end

      it { expect(subject.url).to eq('https://developer.konghq.com/spec/3e65edbc-364d-4762-9d3e-f13083e1b534/33cd4595-e389-4c2b-80ee-5275f25e80e1/') }
    end

    context 'when the url is not absolute' do
      let(:item) do
        {
         'text' => 'Workspaces',
         'url' => '/kong-enterprise/dev-portal/workspaces'
        }
      end

      it 'builds the url based on the options and the url provided' do
        expect(subject.url).to eq('/gateway/3.2.x/kong-enterprise/dev-portal/workspaces/')
      end
    end
  end
end

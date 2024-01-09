RSpec.describe DocsSingleSource::Sidenav do
  before { generate_site! }

  subject { described_class.new(page) }

  describe '#generate' do
    context 'when it is the latest page' do
      let(:page) { find_page_by_url('/gateway/latest/') }

      it 'generates the sidenav drop' do
        expect(Jekyll::Drops::Sidenav)
          .to receive(:new)
          .with(page.data['nav_items'], { 'docs_url' => 'gateway', 'version' => 'latest' })

        subject.generate
      end
    end

    context 'when it is not the latest page' do
      let(:page) { find_page_by_url('/mesh/2.0.x/') }

      it 'generates the sidenav drop' do
        expect(Jekyll::Drops::Sidenav)
          .to receive(:new)
          .with(
            page.data['nav_items'],
            { 'docs_url' => 'mesh', 'version' => kind_of(Jekyll::GeneratorSingleSource::Liquid::Drops::Release) }
          )

        subject.generate
      end
    end

    context 'konnect' do
      let(:page) { find_page_by_url('/konnect/') }

      it 'generates the sidenav drop' do
        expect(Jekyll::Drops::Sidenav)
          .to receive(:new)
          .with(page.data['nav_items'], { 'docs_url' => 'konnect', 'version' => nil })

        subject.generate
      end
    end
  end
end

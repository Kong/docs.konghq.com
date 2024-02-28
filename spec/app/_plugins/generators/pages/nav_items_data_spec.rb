RSpec.describe Jekyll::Pages::NavItemsData do
  before { generate_site! }

  describe '#process!' do
    subject { described_class.new(site: , page:) }

    context 'when it is not a product page' do
      let(:page) { find_page_by_url('/search/') }

      it 'does not modify the page' do
        expect { subject.process! }.not_to change{ page.data }
      end
    end

    context 'when it is a product page' do
      let(:page) { find_page_by_url('/gateway/latest/') }

      context 'it does not set the nav_items if they are set' do
        it { expect { subject.process! }.not_to change { page.data['nav_items'] } }
      end

      context 'it sets the nav_items if they are not set' do
        before do
          page.data['nav_items'] = nil
          subject.process!
        end

        it { expect(page.data['nav_items']).not_to be_nil }
      end

      context 'it sets the sidenav' do
        before { subject.process! }

        it { expect(page.data['sidenav']).to be_an_instance_of(Jekyll::Drops::Sidenav) }
      end

      context 'it sets the releases dropdown' do
        before { subject.process! }

        it { expect(page.data['releases_dropdown']).to be_an_instance_of(Jekyll::Drops::ReleasesDropdown) }
      end
    end
  end
end

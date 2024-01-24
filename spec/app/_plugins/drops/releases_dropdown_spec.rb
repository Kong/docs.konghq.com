RSpec.describe Jekyll::Drops::ReleasesDropdown do
  before { generate_site! }

  let(:page) { find_page_by_url('/gateway/latest/') }

  subject { described_class.new(page) }

  describe '#current' do
    it 'returns the page\'s release' do
      expect(subject.current).to eq('3.0.x')
    end
  end

  describe '#options' do
    it { expect(subject.options).to all(be_a(Jekyll::Drops::Option)) }
    it { expect(subject.options.size).to eq(4) }
  end
end

RSpec.describe Jekyll::Drops::Option do
  let(:page) { find_page_by_url('/gateway/latest/') }
  let(:release) { page.data['release'] }

  before { generate_site! }

  subject { described_class.new(page:, release:) }

  describe '#value' do
    context 'when it is the latest page' do
      it { expect(subject.value).to eq('3.0.x <em>(latest)</em>') }
    end

    context 'when it is not the latest page' do
      let(:page) { find_page_by_url('/gateway/2.6.x/') }

      it { expect(subject.value).to eq('2.6.x') }
    end
  end

  describe '#active?' do
    context 'when the release matches the page\'s release' do
      it { expect(subject.active?).to be_truthy }
    end

    context 'when the release does not match the page\'s release' do
      let(:release) { page.data['releases'].detect { |r| r != page.data['release'] } }

      it { expect(subject.active?).to be_falsey }
    end
  end

  describe '#url' do
    context 'when it is the latest page' do
      it 'replaces the release with `latest`' do
        expect(subject.url).to eq('/gateway/latest/')
      end
    end

    context 'when it is not the latest page' do
      let(:page) { find_page_by_url('/gateway/2.6.x/') }

      it { expect(subject.url).to eq('/gateway/2.6.x/') }
    end
  end

  describe '#data_id' do
    it 'returns the release number' do
      expect(subject.data_id).to eq('3.0.x')
    end
  end
end


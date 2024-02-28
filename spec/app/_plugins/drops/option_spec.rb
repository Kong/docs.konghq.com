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
    before do
      allow(site.data).to receive(:[]).and_call_original
      allow(site.data).to receive(:[]).with('pages_urls').and_return(Set.new(urls))
    end

    context 'previous version' do
      let(:page) { find_page_by_url('/gateway/latest/reference/configuration/') }
      let(:release) do
        Jekyll::GeneratorSingleSource::Product::Release.new(
          'edition' => 'gateway', 'release' => '2.5.x'
        ).to_liquid
      end

      context 'when the url exists' do
        let(:urls) { ['/gateway/2.5.x/reference/configuration/'] }

        it 'it links to it' do
          expect(subject.url).to eq('/gateway/2.5.x/reference/configuration/')
        end
      end

      context 'when the url does not exist' do
        let(:urls) { [] }

        it 'links to the root page' do
          expect(subject.url).to eq('/gateway/2.5.x/')
        end
      end
    end

    context 'future versions' do
      let!(:page) { find_page_by_url('/kubernetes-ingress-controller/2.2.x/introduction/') }

      let(:release) do
        Jekyll::GeneratorSingleSource::Product::Release.new(
          'edition' => 'kubernetes-ingress-controller', 'release' => '2.7.x', 'latest' => true
        ).to_liquid
      end

      context 'when the url exists' do
        let(:urls) { ['/kubernetes-ingress-controller/2.7.x/introduction/'] }

        it 'it links to it' do
          expect(subject.url).to eq('/kubernetes-ingress-controller/2.7.x/introduction/')
        end
      end

      context 'when the url does not exist' do
        let(:urls) { [] }

        it 'links to the root page' do
          expect(subject.url).to eq('/kubernetes-ingress-controller/2.7.x/')
        end
      end
    end
  end

  describe '#data_id' do
    it 'returns the release number' do
      expect(subject.data_id).to eq('3.0.x')
    end
  end
end


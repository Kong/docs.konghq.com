RSpec.describe Utils::CanonicalUrl do
  describe '.generate' do
    subject { described_class.generate(url) }

    context 'when the url has a trailing slash' do
      let(:url) { '/gateway/latest/' }

      it { expect(subject).to eq('/gateway/latest/') }
    end

    context 'when the url does not have a trailing slash' do
      let(:url) { '/gateway/latest' }

      it 'adds a trailing slash' do
        expect(subject).to eq('/gateway/latest/')
      end
    end
  end
end

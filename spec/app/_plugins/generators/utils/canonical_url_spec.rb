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

    context 'if the url has an extension' do
      context '.html' do
        let(:url) { '/index.html' }

        it 'does not alter the original url' do
          expect(subject).to eq('/index.html')
          expect(url).to eq('/index.html')
        end
      end

      context '.xml' do
        let(:url) { '/index.xml' }

        it 'does not alter the original url' do
          expect(subject).to eq('/index.xml')
          expect(url).to eq('/index.xml')
        end
      end
    end
  end
end

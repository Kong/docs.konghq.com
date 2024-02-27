RSpec.describe Jekyll::Drops::Plugins::VersionsDropdownOption do
  subject { described_class.new(page:, release:, latest:, current:) }

  let(:site) { double(data: { 'pages_urls' => Set.new(urls) }) }
  let(:urls) { [] }
  let(:page) do
    double(dropdown_url: '/hub/kong-inc/jwt-signer/VERSION/', site:, base_url: '/hub/kong-inc/jwt-signer/unreleased/')
  end
  let(:current) do
    Jekyll::GeneratorSingleSource::Product::Release.new(
      'edition' => 'gateway', 'release' => '3.5.x'
    ).to_liquid
  end
  let(:release) do
    Jekyll::GeneratorSingleSource::Product::Release.new(
      'edition' => 'gateway', 'release' => release_value
    ).to_liquid
  end
  let(:latest) do
    Jekyll::GeneratorSingleSource::Product::Release.new(
      'edition' => 'gateway', 'release' => '3.5.x', 'latest' => true
    ).to_liquid
  end

  describe '#url' do
    let(:urls) do
      [
        '/hub/kong-inc/jwt-signer/',
        '/hub/kong-inc/jwt-signer/2.8.x/'
      ]
    end

    context 'when the release is the latest' do
      let(:release) { latest }

      it { expect(subject.url).to eq('/hub/kong-inc/jwt-signer/') }
    end

    context 'when the release is not the latest' do
      let(:release_value) { '2.8.x' }

      it { expect(subject.url).to eq('/hub/kong-inc/jwt-signer/2.8.x/') }
    end

    context 'when there is no latest - only release is unreleased' do
      let(:latest) { nil }
      let(:release) do
        Jekyll::GeneratorSingleSource::Product::Release.new(
          'edition' => 'gateway', 'release' => '3.6.x', 'label' => 'unreleased'
        ).to_liquid
      end

      it { expect(subject.url).to eq('/hub/kong-inc/jwt-signer/unreleased/') }
    end
  end

  describe '#css_class' do
    context 'when the release matches current' do
      let(:release_value) { '3.5.x' }

      it { expect(subject.css_class).to eq('active') }
    end

    context 'when the release does not match current' do
      let(:release_value) { '3.4.x' }

      it { expect(subject.css_class).to eq('') }
    end
  end

  describe '#text' do
    context 'when the release is the latest' do
      let(:release) { latest }

      it { expect(subject.text).to eq('3.5.x <em>(latest)</em>') }
    end

    context 'when the release is not the latest' do
      let(:release_value) { '2.8.x' }

      it { expect(subject.text).to eq('2.8.x') }
    end

    context 'when there is no latest - only release is unreleased' do
      let(:latest) { nil }
      let(:release) do
        Jekyll::GeneratorSingleSource::Product::Release.new(
          'edition' => 'gateway', 'release' => '3.6.x', 'label' => 'unreleased'
        ).to_liquid
      end

      it { expect(subject.text.to_s).to eq('unreleased') }
    end
  end
end

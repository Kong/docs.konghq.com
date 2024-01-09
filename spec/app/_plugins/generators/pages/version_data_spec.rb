RSpec.describe Jekyll::Pages::VersionData do
  before { generate_site! }

  subject { described_class.new(site:, page:) }

  describe '#process!' do
    before { subject.process! }

    context 'when it is not a product page' do
      let(:page) { find_page_by_url('/search/') }

      it 'set has_version' do
        expect(page.data['has_version']).to be_falsey
      end
    end

    context 'when it is a product page' do
      let(:releases) do
        YAML.safe_load(File.read('spec/fixtures/app/_data/kong_versions.yml')).select do |v|
          v['edition'] == 'gateway'
        end
      end
      let(:latest_release) { releases.detect { |v| v['latest'] } }

      let(:page) { find_page_by_url('/gateway/3.0.x/') }

      it 'sets that it has a version' do
        expect(page.data['has_version']).to be_truthy
      end

      it 'sets the edition ' do
        expect(page.data['edition']).to eq('gateway')
      end

      it 'sets releases' do
        expect(page.data['releases']).to all(be_a(Jekyll::GeneratorSingleSource::Liquid::Drops::Release))
        expect(page.data['releases'].map(&:value)).to match_array(['2.6.x', '2.7.x', '2.8.x', '3.0.x'])
      end

      it 'sets kong_versions' do
        expect(page.data['kong_versions']).to match_array(releases)
      end

      it 'sets kong_latest' do
        expect(page.data['kong_latest']).to eq(latest_release)
      end

      it 'sets kong_version' do
        expect(page.data['kong_version']).to eq('3.0.x')
      end

      it 'sets the default version if any' do
        expect(page.data['version']).to be_nil
      end

      it 'sets release' do
        expect(page.data['release']).to be_an_instance_of(Jekyll::GeneratorSingleSource::Liquid::Drops::Release)
      end

      it 'sets versions' do
        expect(page.data['versions']).to eq({ 'ee' => '3.0.1.0', 'ce' => '3.0.1' })
      end

      it 'sets version_data' do
        expect(page.data['version_data']).to eq(latest_release)
      end

      it 'sets major_minor_version' do
        expect(page.data['major_minor_version']).to eq('30')
      end

      context 'release with a single version' do
        let(:page) { find_page_by_url('/mesh/2.1.x/') }

        it 'sets the default version if any' do
          expect(page.data['version']).to eq('2.1.0')
        end
      end
    end
  end
end

RSpec.describe Jekyll::Versions do
  let(:kong_versions) do
    SafeYAML.load(File.read(File.join(site.source, '_data/kong_versions.yml')))
  end

  let(:deck_versions) do
    kong_versions.select { |v| v.fetch('edition') == 'deck' }
  end

  let(:mesh_versions) do
    kong_versions.select { |v| v.fetch('edition') == 'mesh' }
  end

  let(:kubernetes_ingress_controller_versions) do
    kong_versions.select { |v| v.fetch('edition') == 'kubernetes-ingress-controller'}
  end

  let(:gateway_versions) do
    kong_versions.select { |v| v.fetch('edition') == 'gateway'}
  end

  let(:latest_gateway) do
    { 'release' => '3.0.x', 'ee-version' => '3.0.1.0', 'ce-version' => '3.0.1', 'latest' => true }
  end

  let(:latest_mesh) do
    { 'release' => '2.1.x', 'version' => '2.1.0', 'edition' => 'mesh', 'latest' => true }
  end

  let(:latest_kic) do
    { 'release' => '2.7.x', 'version' => '2.7.0', 'edition' => 'kubernetes-ingress-controller', 'latest' => true }
  end

  let(:latest_deck) do
    { 'release' => '1.16.x', 'version' => '1.16.1', 'edition' => 'deck', 'latest' => true }
  end

  shared_examples_for 'does not set `release` and `version` to the page' do
    it do
      expect(page.data['release']).to be_nil
      expect(page.data['version']).to be_nil
    end
  end

  shared_examples_for 'sets `release` and `version` to the page' do |release, version|
    it do
      expect(page.data['release'].to_s).to eq(release)
      expect(page.data['version']).to eq(version)
    end
  end

  before do
    PluginSingleSource::Generator.new.generate(site)
    Jekyll::GeneratorSingleSource::Generator.new.generate(site)
  end

  describe '#generate' do
    before { described_class.new.generate(site) }

    it 'sets kong_versions to the site' do
      expect(site.data['kong_versions_deck']).to eq(deck_versions)
      expect(site.data['kong_versions_mesh']).to eq(mesh_versions)
      expect(site.data['kong_versions_konnect']).to eq(['edition' => 'konnect'])
      expect(site.data['kong_versions_kic']).to eq(kubernetes_ingress_controller_versions)
      expect(site.data['kong_versions_contributing']).to eq(['edition' => 'contributing'])
      expect(site.data['kong_versions_gateway']).to eq(gateway_versions)
    end

    it 'sets the latest versions of the products to the site' do
      expect(site.data['kong_latest_mesh']).to eq(latest_mesh)
      expect(site.data['kong_latest_KIC']).to eq(latest_kic)
      expect(site.data['kong_latest_deck']).to eq(latest_deck)
      expect(site.data['kong_latest_gateway']).to include(latest_gateway)
    end

    context 'For pages under app/' do
      let(:page) { site.pages.detect { |p| p.relative_path == relative_path } }

      context 'mesh' do
        context 'with version' do
          let(:relative_path) { 'mesh/1.6.x/index.md' }

          it 'adds version properties' do
            expect(page.data['has_version']).to eq(true)
            expect(page.data['edition']).to eq('mesh')
            expect(page.data['releases_hash']).to eq(mesh_versions)
            expect(page.data['kong_latest']).to eq(latest_mesh)
            expect(page.data['nav_items']).to eq(site.data.fetch('docs_nav_mesh_16x'))
          end

          it_behaves_like 'sets `release` and `version` to the page', '1.6.x', '1.6.1'

          context 'latest version' do
            let(:relative_path) { 'mesh/2.0.x/index.md' }

          end
        end

        context 'without version' do
          let(:relative_path) { 'mesh/changelog.md' }

          it 'adds version properties' do
            expect(page.data['has_version']).to eq(false)
            expect(page.data['edition']).to eq('mesh')
            expect(page.data['releases_hash']).to eq(mesh_versions)
            expect(page.data['kong_latest']).to eq(latest_mesh)
            expect(page.data['nav_items']).to be_nil
          end

          it_behaves_like 'does not set `release` and `version` to the page'
        end
      end

      context 'konnect' do
        let(:relative_path) { 'konnect/index.md' }

        it 'adds version properties' do
          expect(page.data['has_version']).to eq(false)
          expect(page.data['edition']).to eq('konnect')
          expect(page.data['releases_hash']).to eq(['edition' => 'konnect'])
          expect(page.data['nav_items']).to eq(site.data.fetch('docs_nav_konnect'))
        end

        it_behaves_like 'does not set `release` and `version` to the page'
      end

      context 'kubernetes-ingress-controller' do
        context 'latest' do
          let(:relative_path) { 'kubernetes-ingress-controller/2.2.x/index.md' }

          it 'adds version properties' do
            expect(page.data['has_version']).to eq(true)
            expect(page.data['edition']).to eq('kubernetes-ingress-controller')
            expect(page.data['releases_hash']).to eq(kubernetes_ingress_controller_versions)
            expect(page.data['kong_latest']).to eq(latest_kic)
            expect(page.data['nav_items']).to eq(site.data.fetch('docs_nav_kic_22x'))
          end

          it_behaves_like 'sets `release` and `version` to the page', '2.2.x', '2.2.0'
        end

        context 'previous' do
          let(:relative_path) { 'kubernetes-ingress-controller/2.1.x/index.md' }

          it 'adds version properties' do
            expect(page.data['has_version']).to eq(true)
            expect(page.data['edition']).to eq('kubernetes-ingress-controller')
            expect(page.data['releases_hash']).to eq(kubernetes_ingress_controller_versions)
            expect(page.data['kong_latest']).to eq(latest_kic)
            expect(page.data['nav_items']).to eq(site.data.fetch('docs_nav_kic_21x'))
          end

          it_behaves_like 'sets `release` and `version` to the page', '2.1.x', '2.1.0'
        end
      end

      context 'deck' do
        let(:relative_path) { 'deck/pre-1.7/index.md' }

        it 'adds version properties' do
          expect(page.data['has_version']).to eq(true)
          expect(page.data['edition']).to eq('deck')
          expect(page.data['releases_hash']).to eq(deck_versions)
          expect(page.data['kong_latest']).to eq(latest_deck)
          expect(page.data['nav_items']).to eq(site.data['docs_nav_deck_pre-1.7'])
        end

        it 'sets `release` and `version` to the page' do
          expect(page.data['release'].to_s).to eq('pre-1.7')
          expect(page.data['version']).to eq('1.6.0')
        end
      end

      context 'gateway' do
        context 'with version' do
          let(:relative_path) { 'gateway/2.6.x/index.md' }

          it 'adds version properties' do
            expect(page.data['has_version']).to eq(true)
            expect(page.data['edition']).to eq('gateway')
            expect(page.data['releases_hash']).to eq(gateway_versions)
            expect(page.data['kong_latest']).to include(latest_gateway)
            expect(page.data['nav_items']).to eq(site.data.fetch('docs_nav_gateway_26x'))
          end

          it 'sets `release` and `version` to the page' do
            expect(page.data['release'].to_s).to eq('2.6.x')
            expect(page.data['version']).to be_nil
          end
        end

        context 'without version' do
          let(:relative_path) { 'gateway/changelog.md' }

          it 'adds version properties' do
            expect(page.data['has_version']).to eq(false)
            expect(page.data['edition']).to eq('gateway')
            expect(page.data['releases_hash']).to eq(gateway_versions)
            expect(page.data['kong_latest']).to include(latest_gateway)
            expect(page.data['nav_items']).to be_nil
          end

          it_behaves_like 'does not set `release` and `version` to the page'
        end
      end

      context 'contributing' do
        let(:relative_path) { 'contributing/index.md' }

        it 'adds version properties' do
          expect(page.data['has_version']).to eq(false)
          expect(page.data['edition']).to eq('contributing')
          expect(page.data['releases_hash']).to eq(['edition' => 'contributing'])
          expect(page.data['kong_latest']).to be_nil
          expect(page.data['nav_items']).to eq(site.data['docs_nav_contributing'])
        end

        it_behaves_like 'does not set `release` and `version` to the page'
      end

      context 'pages that are not documentation' do
        shared_examples_for 'only sets has_version' do
          it do
            expect(page.data['has_version']).to eq(false)
            expect(page.data['edition']).to be_nil
            expect(page.data['releases_hash']).to be_nil
            expect(page.data['kong_latest']).to be_nil
            expect(page.data['nav_items']).to be_nil
          end
        end

        ['404.html', 'index.md', 'kuma-to-kong-mesh.md'].each do |path|
          let(:relative_path) { path }

          it_behaves_like 'only sets has_version'
          it_behaves_like 'does not set `release` and `version` to the page'
        end
      end

      context 'single sourced pages' do
        context 'deck' do
          let(:relative_path) { '_src/deck/index.md' }

          it 'adds version properties' do
            expect(page.data['has_version']).to eq(true)
            expect(page.data['edition']).to eq('deck')
            expect(page.data['releases_hash']).to eq(deck_versions)
            expect(page.data['kong_latest']).to eq(latest_deck)
          end

          it 'does not change the `release` and `version` set in the single sourced generator ' do
            expect(page.data['release'].to_s).to eq('1.16.x')
            expect(page.data['version']).to eq('1.16.1')
          end

          it 'cleans up nav_items for single sourced pages' do
            expect(page.data['nav_items']).to eq(site.data.fetch('docs_nav_deck_116x').fetch('items'))
          end
        end

        context 'gateway' do
          let(:relative_path) { '_src/gateway/index.md' }

          it 'adds version properties' do
            expect(page.data['has_version']).to eq(true)
            expect(page.data['edition']).to eq('gateway')
            expect(page.data['releases_hash']).to eq(gateway_versions)
            expect(page.data['kong_latest']).to include(latest_gateway)
          end

          it 'does not change the `release` and `version` set in the single sourced generator ' do
            expect(page.data['release'].to_s).to eq('3.0.x')
            expect(page.data['version']).to be_nil
          end

          it 'cleans up nav_items for single sourced pages' do
            expect(page.data['nav_items']).to eq(site.data.fetch('docs_nav_gateway_30x').fetch('items'))
          end
        end

        context 'kubernetes-ingress-controller' do
          let(:relative_path) { '_src/kubernetes-ingress-controller/index.md' }

          it 'adds version properties' do
            expect(page.data['has_version']).to eq(true)
            expect(page.data['edition']).to eq('kubernetes-ingress-controller')
            expect(page.data['releases_hash']).to eq(kubernetes_ingress_controller_versions)
            expect(page.data['kong_latest']).to eq(latest_kic)
          end

          it 'does not change the `release` and `version` set in the single sourced generator ' do
            expect(page.data['release'].to_s).to eq('2.7.x')
            expect(page.data['version']).to eq('2.7.0')
          end

          it 'cleans up nav_items for single sourced pages' do
            expect(page.data['nav_items']).to eq(site.data.fetch('docs_nav_kic_27x').fetch('items'))
          end
        end

        context 'mesh' do
          let(:relative_path) { '_src/mesh/index.md' }

          it 'adds version properties' do
            expect(page.data['has_version']).to eq(true)
            expect(page.data['edition']).to eq('mesh')
            expect(page.data['releases_hash']).to eq(mesh_versions)
            expect(page.data['kong_latest']).to eq(latest_mesh)
          end

          it 'does not change the `release` and `version` set in the single sourced generator ' do
            expect(page.data['release'].to_s).to eq('2.0.x')
            expect(page.data['version']).to eq('2.0.0')
          end

          it 'cleans up nav_items for single sourced pages' do
            expect(page.data['nav_items']).to eq(site.data.fetch('docs_nav_mesh_20x').fetch('items'))
          end
        end
      end
    end
  end
end

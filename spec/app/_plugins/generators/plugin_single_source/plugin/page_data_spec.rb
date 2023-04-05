RSpec.describe PluginSingleSource::Plugin::PageData do
  let(:plugin_name) { 'kong-inc/jwt-signer' }
  let(:plugin) do
    PluginSingleSource::Plugin::Base.make_for(dir: plugin_name, site:)
  end
  let(:release) do
    PluginSingleSource::Plugin::Release.new(site:, version:, plugin:, is_latest:, source:)
  end

  subject { described_class.generate(release:) }

  shared_examples_for 'includes the hub_examples' do
    it { expect(subject['hub_examples']).to be_an_instance_of(Jekyll::Drops::Plugins::HubExamples) }
  end

  shared_examples_for 'includes the schema' do
    it { expect(subject['schema']).to be_an_instance_of(Jekyll::Drops::Plugins::Schema) }
  end

  describe '#build_data' do
    context 'when it is the latest version of the plugin' do
      let(:is_latest) { true }
      let(:version) { '2.8.x' }
      let(:source) { '_index' }

      it 'includes the attributes defined in the frontmatter' do
        expect(subject).to include(
          'name' => 'Kong JWT Signer',
          'publisher' => 'Kong Inc.',
          'desc' => 'Verify and sign one or two tokens in a request',
          'description' => "From \\_index.md: The Kong JWT Signer plugin makes it possible to verify, sign, or re-sign\none or two tokens in a request. With a two token request, one token\nis allocated to an end user and the other token to the client application,\nfor example.\n",
          'enterprise' => true,
          'plus' => true,
          'type' => 'plugin',
          'kong_version_compatibility' => { 'community_edition' => { 'compatible' => nil }, 'enterprise_edition' => { 'compatible' => true } }
        )
      end

      it 'includes the page attributes' do
        expect(subject).to include(
          'is_latest' => true,
          'seo_noindex' => nil,
          'version' => version,
          'extn_slug' => 'jwt-signer',
          'extn_publisher' => 'kong-inc',
          'extn_release' => '2.8.x',
          'extn_icon' => '/assets/images/icons/hub/kong-inc_jwt-signer.png',
          'layout' => 'extension',
          'book' => 'plugins/kong-inc/jwt-signer/2.8.x'
        )
      end

      it 'includes the attributes defined in _configuration.yml' do
        expect(subject['metadata'])
          .to include(SafeYAML.load(File.read(File.expand_path('_hub/kong-inc/jwt-signer/_configuration.yml', site.source))))
      end

      it_behaves_like 'includes the hub_examples'

      it_behaves_like 'includes the schema'
    end

    context 'when it is not the latest version of the plugin' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }

      it 'includes the attributes defined in the frontmatter' do
        expect(subject).to include(
          'name' => 'Kong JWT Signer',
          'publisher' => 'Kong Inc.',
          'desc' => 'Verify and (re-)sign one or two tokens in a request',
          'description' => "From \\_2.2.x.md: The Kong JWT Signer plugin makes it possible to verify and (re-)sign one or two tokens in a request.\n",
          'enterprise' => true,
          'plus' => true,
          'type' => 'plugin',
          'kong_version_compatibility' => { 'community_edition' => { 'compatible' => nil }, 'enterprise_edition' => { 'compatible' => true } }
        )
      end

      it 'includes the page attributes' do
        expect(subject).to include(
          'is_latest' => false,
          'seo_noindex' => true,
          'version' => version,
          'extn_slug' => 'jwt-signer',
          'extn_publisher' => 'kong-inc',
          'extn_release' => '2.5.x',
          'extn_icon' => '/assets/images/icons/hub/kong-inc_jwt-signer.png',
          'layout' => 'extension',
          'book' => 'plugins/kong-inc/jwt-signer/2.5.x'
        )
      end

      it 'includes the attributes defined in _configuration.yml' do
        expect(subject['metadata'])
          .to include(SafeYAML.load(File.read(File.expand_path('_hub/kong-inc/jwt-signer/_2.2.x/_configuration.yml', site.source))))
      end

      it_behaves_like 'includes the hub_examples'

      it_behaves_like 'includes the schema'
    end

    context 'when there are frontmatter overrides' do
      let(:plugin_name) { 'acme/unbundled-plugin' }
      let(:source) { '_index' }
      let(:is_latest) { true }
      let(:version) { '3.0.x' }

      it 'includes overrides attributes with the content of `frontmatter` in the corresponding versions.yml' do
        expect(subject).to include('bundled' => false)
      end
    end
  end
end

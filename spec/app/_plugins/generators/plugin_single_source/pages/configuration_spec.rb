RSpec.describe PluginSingleSource::Pages::Configuration do
  let(:plugin_name) { 'kong-inc/jwt-signer' }
  let(:plugin) { PluginSingleSource::Plugin::Base.make_for(dir: plugin_name, site:) }
  let(:release) { PluginSingleSource::Plugin::Release.new(site:, version:, plugin:, is_latest:) }
  let(:file) { "app/_src/.repos/kong-plugins/schemas/jwt-signer/#{version}.json" }
  let(:is_latest) { true }
  let(:version) { '2.8.x' }

  subject { described_class.new(release:, file:, source_path:) }

  describe '#data' do
    let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

    before do
      expect(PluginSingleSource::Plugin::PageData).to receive(:generate).and_call_original
    end

    it 'returns a hash containing the data needed to render the templates' do
      expect(subject.data).to include({
        'canonical_url' => '/hub/kong-inc/jwt-signer/configuration/',
        'source_file' => '_src/.repos/kong-plugins/schemas/jwt-signer/2.8.x.json',
        'permalink' => '/hub/kong-inc/jwt-signer/configuration/',
        'ssg_hub' => false,
        'title' => 'Kong JWT Signer Configuration'
      })
    end
  end

  describe '#source_file' do
    let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

    it 'returns the relative path from app/ to the schema file' do
      expect(subject.source_file).to eq('_src/.repos/kong-plugins/schemas/jwt-signer/2.8.x.json')
    end
  end

  describe '#canonical_url' do
    let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

    it { expect(subject.canonical_url).to eq('/hub/kong-inc/jwt-signer/configuration/') }
  end

  describe '#permalink' do
    context 'when it is the latest release' do
      let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

      it { expect(subject.permalink).to eq('/hub/kong-inc/jwt-signer/configuration/') }
    end

    context 'when it is not the latest release' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source_path) { File.expand_path("_hub/kong-inc/jwt-signer/", site.source) }

      it { expect(subject.permalink).to eq('/hub/kong-inc/jwt-signer/2.5.x/configuration/') }
    end
  end

  describe '#nav_title' do
    let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

    it { expect(subject.nav_title).to eq('Configuration reference') }
  end

  describe '#edit_link' do
    context 'kong-inc plugins' do
      context 'enterprise plugins' do
        let(:plugin_name) { 'kong-inc/jwt-signer' }
        let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

        it { expect(subject.edit_link).to eq('https://github.com/Kong/kong-ee/edit/master/plugins-ee/jwt-signer/kong/plugins/jwt-signer/schema.lua') }
      end

      context 'non-enterprise plugins' do
        let(:plugin_name) { 'kong-inc/jq' }
        let(:source_path) { File.expand_path('_hub/kong-inc/jq/', site.source) }
        let(:file) { "app/_src/.repos/kong-plugins/schemas/jq/#{version}.json" }

        it { expect(subject.edit_link).to eq('https://github.com/Kong/kong/edit/master/kong/plugins/jq/schema.lua') }
      end
    end

    context 'third-party plugins' do
      let(:plugin_name) { 'acme/kong-plugin' }
      let(:source_path) { File.expand_path('_hub/acme/kong-plugin/', site.source) }
      let(:file) { "app/_hub/acme/kong-plugin/schemas/_index.json" }

      it { expect(subject.edit_link).to eq('https://github.com/Kong/docs.konghq.com/edit/main/spec/fixtures/app/_hub/acme/kong-plugin/schemas/_index.json') }
    end
  end

  describe '#breadcrumbs' do
    let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

    it 'returns a hash containing the page\'s breadcrumbs' do
      expect(subject.breadcrumbs).to eq([
        { text: 'Authentication', url: '/hub/?category=authentication' },
        { text: 'Kong JWT Signer', url: '/hub/kong-inc/jwt-signer/' },
        { text: 'Configuration', url: '/hub/kong-inc/jwt-signer/configuration/' }
      ])
    end
  end
end

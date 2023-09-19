RSpec.describe PluginSingleSource::Pages::ConfigurationExamples do
  let(:plugin_name) { 'kong-inc/jwt-signer' }
  let(:plugin) { PluginSingleSource::Plugin::Base.make_for(dir: plugin_name, site:) }
  let(:release) { PluginSingleSource::Plugin::Release.new(site:, version:, plugin:, is_latest:, source:) }
  let(:file) { "app/_src/.repos/kong-plugins/examples/jwt-signer/_#{version}.yaml" }

  subject { described_class.new(release:, file:, source_path:) }

  describe '#edit_link' do
    let(:is_latest) { true }
    let(:source) { '_index' }
    let(:version) { '2.8.x' }

    context 'kong-inc plugins' do
      context 'enterprise plugins' do
        let(:plugin_name) { 'kong-inc/jwt-signer' }
        let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

        it { expect(subject.edit_link).to eq('https://github.com/Kong/docs-plugin-toolkit/edit/main/examples/jwt-signer/_2.8.x.yaml') }
      end

      context 'non-enterprise plugins' do
        let(:plugin_name) { 'kong-inc/jq' }
        let(:source_path) { File.expand_path('_hub/kong-inc/jq/', site.source) }

        it { expect(subject.edit_link).to eq('https://github.com/Kong/docs-plugin-toolkit/edit/main/examples/jq/_2.8.x.yaml') }
      end
    end

    context 'third-party plugins' do
      let(:plugin_name) { 'acme/kong-plugin' }
      let(:source_path) { File.expand_path('_hub/acme/kong-plugin/', site.source) }
      let(:file) { 'app/_hub/acme/kong-plugin/examples/_index.yml' }

      it { expect(subject.edit_link).to eq('https://github.com/Kong/docs.konghq.com/edit/main/app/_hub/acme/kong-plugin/examples/_index.yml') }
    end
  end

  describe '#breadcrumbs' do
    context 'when _index.md exist' do
      let(:is_latest) { true }
      let(:version) { '2.8.x' }
      let(:source) { '_index' }
      let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

      it 'returns a hash containing the page\'s breadcrumbs' do
        expect(subject.breadcrumbs).to eq([
          { text: 'Authentication', url: '/hub/?category=authentication' },
          { text: 'Kong JWT Signer', url: '/hub/kong-inc/jwt-signer/' },
          { text: 'How to', url: '/hub/kong-inc/jwt-signer/how-to/' },
          { text: 'Basic config examples', url: '/hub/kong-inc/jwt-signer/how-to/basic-example/' }
        ])
      end
    end

    context 'when _index.md does not exist' do
      let(:plugin) { PluginSingleSource::Plugin::Base.make_for(dir: 'acme/kong-plugin', site:) }
      let(:is_latest) { true }
      let(:version) { '2.8.x' }
      let(:source) { '_index' }
      let(:file) { 'how-to/_local-testing.md' }
      let(:source_path) { File.expand_path("_hub/acme/kong-plugin/#{source}/", site.source) }

      it 'returns a hash containing the page\'s breadcrumbs' do
        expect(subject.breadcrumbs).to eq([
          { text: 'Logging', url: '/hub/?category=logging' },
          { text: 'Sample plugin', url: '/hub/acme/kong-plugin/' },
          { text: 'How to', url: nil },
          { text: 'Basic config examples', url: '/hub/acme/kong-plugin/how-to/basic-example/' }
        ])
      end
    end
  end

  describe '#source_file' do
    let(:is_latest) { true }
    let(:source) { '_index' }
    let(:version) { '2.8.x' }

    context 'third-party plugins' do
      let(:plugin_name) { 'acme/kong-plugin' }
      let(:source_path) { File.expand_path('_hub/acme/kong-plugin/', site.source) }
      let(:file) { 'app/_hub/acme/kong-plugin/examples/_index.yml' }

      it 'returns the relative path from app/ to the example file' do
        expect(subject.source_file).to eq('_hub/acme/kong-plugin/examples/_index.yml')
      end
    end

    context 'kong plugins' do
      let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

      it 'returns the relative path from app/ to the example file' do
        expect(subject.source_file).to eq('_src/.repos/kong-plugins/examples/jwt-signer/_2.8.x.yaml')
      end
    end
  end
end

RSpec.describe PluginSingleSource::Pages::ConfigurationExamples do
  let(:plugin_name) { 'kong-inc/jwt-signer' }
  let(:plugin) { PluginSingleSource::Plugin::Base.make_for(dir: plugin_name, site:) }
  let(:release) { PluginSingleSource::Plugin::Release.new(site:, version:, plugin:, is_latest:, source:) }

  subject { described_class.new(release:, file: nil, source_path:) }

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

      it { expect(subject.edit_link).to eq('https://github.com/Kong/docs.konghq.com/edit/main/app/_hub/acme/kong-plugin/examples/_index.yml') }
    end
  end
end

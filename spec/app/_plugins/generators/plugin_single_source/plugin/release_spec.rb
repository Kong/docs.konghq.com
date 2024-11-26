RSpec.describe PluginSingleSource::Plugin::Release do
  let(:plugin_name) { 'kong-inc/jwt-signer' }
  let(:is_latest) { true }
  let(:version) { '2.8.x' }
  let(:plugin) do
    PluginSingleSource::Plugin::Base.make_for(dir: plugin_name, site:)
  end

  subject { described_class.new(site:, version:, plugin:, is_latest:) }

  describe '#metadata' do
    context 'when there is a specific metadata file for the version' do
      let(:is_latest) { false }
      let(:version) { '2.6.x' }

      it 'returns the content of the _metadata.yml inside the corresponding folder' do
        expect(subject.metadata)
          .to eq(SafeYAML.load(File.read(File.expand_path('_hub/kong-inc/jwt-signer/_metadata/_2.6.x.yml', site.source))))
      end
    end

    it 'returns the content of the _metadata.yml at the top level' do
      expect(subject.metadata)
        .to eq(SafeYAML.load(File.read(File.expand_path('_hub/kong-inc/jwt-signer/_metadata/_index.yml', site.source))))
    end
  end

  describe '#latest?' do
    it { expect(subject.latest?).to eq(is_latest) }
  end

  describe '#generate_pages' do
    context 'for a specific version' do
      let(:is_latest) { false }
      let(:version) { '2.7.x' }

      it 'returns the relative path to the _index.md file inside the corresponding folder' do
        expect(subject.generate_pages.map(&:permalink)).to match_array([
          '/hub/kong-inc/jwt-signer/2.7.x/',
          '/hub/kong-inc/jwt-signer/2.7.x/changelog/',
          '/hub/kong-inc/jwt-signer/2.7.x/how-to/',
          '/hub/kong-inc/jwt-signer/2.7.x/configuration/',
          '/hub/kong-inc/jwt-signer/2.7.x/how-to/basic-example/',
          '/hub/kong-inc/jwt-signer/2.7.x/how-to/nested/tutorial/'
        ])
      end
    end

    it 'returns the relative path to the top-level _index.md file' do
      expect(subject.generate_pages.compact.map(&:permalink)).to match_array([
        '/hub/kong-inc/jwt-signer/',
        '/hub/kong-inc/jwt-signer/nested/',
        '/hub/kong-inc/jwt-signer/changelog/',
        '/hub/kong-inc/jwt-signer/how-to/',
        '/hub/kong-inc/jwt-signer/how-to/nested/tutorial/',
        '/hub/kong-inc/jwt-signer/configuration/',
        '/hub/kong-inc/jwt-signer/how-to/basic-example/',
        '/hub/kong-inc/jwt-signer/how-to/nested/tutorial-with-min-and-max/'
      ])
    end
  end

  describe '#schema' do
    context 'kong-inc plugin' do
      context 'app-dynamics' do
        let(:plugin_name) { 'kong-inc/app-dynamics' }
        it { expect(subject.schema).to be_an_instance_of(PluginSingleSource::Plugin::Schemas::Kong) }
      end

      context 'otherwise' do
        it { expect(subject.schema).to be_an_instance_of(PluginSingleSource::Plugin::Schemas::Kong) }
      end
    end

    context 'third-party plugin' do
      let(:plugin_name) { 'okta/okta' }
      it { expect(subject.schema).to be_an_instance_of(PluginSingleSource::Plugin::Schemas::ThirdParty) }
    end
  end

  describe '#changelog' do
    let(:plugin_name) { 'acme/unbundled-plugin' }
    it { expect(subject.changelog).to be_an_instance_of(PluginSingleSource::Pages::Changelog) }

    context 'when there is no _changelog.md' do
      let(:plugin_name) { 'acme/kong-plugin' }

      it { expect(subject.changelog).to be_nil }
    end
  end

  describe '#enterprise_plugin?' do
    context 'when the plugin is `enterprise` and not `free`' do
      let(:plugin_name) { 'acme/unbundled-plugin' }

      it { expect(subject.enterprise_plugin?).to eq(true) }
    end

    context 'otherwise' do
      let(:plugin_name) { 'acme/jq' }

      it { expect(subject.enterprise_plugin?).to eq(false) }
    end
  end

  describe '#configuration' do
    let(:file) { File.join(PluginSingleSource::Plugin::Schemas::Kong::SCHEMAS_PATH, "jwt-signer/#{version}.json") }

    it 'returns an instance of Pages::Configuration' do
      expect(PluginSingleSource::Pages::Configuration)
        .to receive(:new)
        .with(release: subject, file: , source_path: '')

      subject.configuration
    end
  end

  describe '#configuration_examples' do
    let(:file) { "_src/.repos/kong-plugins/examples/jwt-signer/_#{version}.yaml" }

    it 'returns an instance of Pages::ConfigurationExamples' do
      expect(PluginSingleSource::Pages::ConfigurationExamples)
        .to receive(:new)
        .with(release: subject, file: , source_path: '')

      subject.configuration_examples
    end
  end
end

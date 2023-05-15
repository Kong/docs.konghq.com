RSpec.describe PluginSingleSource::Plugin::Release do
  let(:plugin_name) { 'kong-inc/jwt-signer' }
  let(:is_latest) { true }
  let(:source) { '_index' }
  let(:version) { '2.8.x' }
  let(:plugin) do
    PluginSingleSource::Plugin::Base.make_for(dir: plugin_name, site:)
  end

  subject { described_class.new(site:, version:, plugin:, is_latest:, source:) }

  describe '#metadata' do
    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }

      it 'returns the content of the _metadata.yml inside the corresponding folder' do
        expect(subject.metadata)
          .to eq(SafeYAML.load(File.read(File.expand_path('_hub/kong-inc/jwt-signer/_2.2.x/_metadata.yml', site.source))))
      end
    end

    context 'when using `_index.md`' do
      it 'returns the content of the _metadata.yml at the top level' do
        expect(subject.metadata)
          .to eq(SafeYAML.load(File.read(File.expand_path('_hub/kong-inc/jwt-signer/_metadata.yml', site.source))))
      end
    end
  end

  describe '#latest?' do
    it { expect(subject.latest?).to eq(is_latest) }
  end

  describe '#generate_pages' do
    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }

      it 'returns the relative path to the _index.md file inside the corresponding folder' do
        expect(subject.generate_pages.map(&:permalink)).to match_array([
          '/hub/kong-inc/jwt-signer/2.5.x/',
          '/hub/kong-inc/jwt-signer/2.5.x/changelog/',
          '/hub/kong-inc/jwt-signer/2.5.x/how-to/',
          '/hub/kong-inc/jwt-signer/2.5.x/configuration/'
        ])
      end
    end

    context 'when using `_index.md`' do
      it 'returns the relative path to the top-level _index.md file' do
        expect(subject.generate_pages.map(&:permalink)).to match_array([
          '/hub/kong-inc/jwt-signer/',
          '/hub/kong-inc/jwt-signer/changelog/',
          '/hub/kong-inc/jwt-signer/how-to/',
          '/hub/kong-inc/jwt-signer/how-to/nested/tutorial/',
          '/hub/kong-inc/jwt-signer/configuration/',
        ])
      end
    end
  end

  describe 'Validations' do
    context 'when the `source` does not start with `_`' do
      let(:source) { 'index' }
      let(:version) { '3.0.x' }
      let(:is_latest) { true }

      it 'raises an expection' do
        expect { subject }.to raise_error(ArgumentError)
      end
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
end

RSpec.describe PluginSingleSource::Plugin::Versioned do
  let(:dir) { [author, name].join('/') }
  let(:name) { 'jq' }
  let(:author) { 'kong-inc' }

  subject { described_class.new(dir:, site:) }

  it_behaves_like 'a Plugin'

  describe '#extension?' do
    it { expect(subject.extension?).to eq(true) }
  end

  describe '#set_version?' do
    context 'when there is more than one release' do
      it { expect(subject.set_version?).to eq(true) }
    end
  end

  describe '#releases' do
    let(:name) { 'jwt-signer' }

    context 'when a `maximum_version` is set' do
      it 'returns the versions defined in `kong_versions.yml` in the `minimum_version` `maximum_version` range, replacements apply' do
        expect(subject.releases).to eq(
          ['2.8.x', '2.7.x', '2.6.x', '2.5.x', '2.4.x', '2.3.x-EE', '2.3.x-CE']
        )
      end
    end

    context 'when `maximum_version` is not set' do
      let(:data) do
        data = SafeYAML.load(
          File.read('spec/fixtures/app/_hub/kong-inc/jwt-signer/versions.yml')
        )
        data['releases'].delete('maximum_version')
        data
      end

      before { allow(subject).to receive(:data).and_return(data) }

      it 'returns the versions defined in `kong_versions.yml` greater than and equal to `minimum_version`, replacements apply' do
        expect(subject.releases).to eq(
          ['3.0.x', '2.8.x', '2.7.x', '2.6.x', '2.5.x', '2.4.x', '2.3.x-EE', '2.3.x-CE']
        )
      end
    end

    context 'when `minimum_version` is not present' do
      let(:data) { { 'releases' => {} } }

      before { allow(subject).to receive(:data).and_return(data) }

      it { expect{ subject.releases }
        .to raise_error(ArgumentError, '`releases` must have a `minimum_version` version set') }
    end
  end

  describe '#sources' do
    context 'when the key is not present in `versions.yml`' do
      it { expect(subject.sources).to eq({}) }
    end

    context 'when the key is present' do
      let(:name) { 'jwt-signer' }

      it 'returns the sources defined in the file' do
        expect(subject.sources).to eq({
          '2.5.x' => '_2.2.x',
          '2.4.x' => '_2.2.x',
          '2.3.x' => '_2.2.x',
          '2.2.x' => '_2.2.x'
        })
      end
    end
  end

  describe '#create_pages' do
    it 'creates a page for each version of the plugin' do
      expect(PluginSingleSource::Plugin::Release)
        .to receive(:new)
        .with(site:, version: '3.0.x', is_latest: true, plugin: subject, source: '_index')
        .and_call_original
      expect(PluginSingleSource::Plugin::Release)
        .to receive(:new)
        .with(site:, version: '2.8.x', is_latest: false, plugin: subject, source: '_index')
        .and_call_original
      expect(PluginSingleSource::Plugin::Release)
        .to receive(:new)
        .with(site:, version: '2.7.x', is_latest: false, plugin: subject, source: '_index')
        .and_call_original
      expect(PluginSingleSource::Plugin::Release)
        .to receive(:new)
        .with(site:, version: '2.6.x', is_latest: false, plugin: subject, source: '_index')
        .and_call_original

      expect(subject.create_pages.size).to eq(16)
    end

    context 'when there is a file for a specific version or `source` present ' do
      let(:name) { 'jwt-signer' }

      it 'creates a page for each version of the plugin, except for those for which a .md file exist' do
        expect(PluginSingleSource::Plugin::Release)
          .to receive(:new)
          .with(site:, version: '2.8.x', is_latest: true, plugin: subject, source: '_index')
          .and_call_original
        expect(PluginSingleSource::Plugin::Release)
          .to receive(:new)
          .with(site:, version: '2.7.x', is_latest: false, plugin: subject, source: '_index')
          .and_call_original
        expect(PluginSingleSource::Plugin::Release)
          .to receive(:new)
          .with(site:, version: '2.6.x', is_latest: false, plugin: subject, source: '_index')
          .and_call_original
        expect(PluginSingleSource::Plugin::Release)
          .to receive(:new)
          .with(site:, version: '2.5.x', is_latest: false, plugin: subject, source: '_2.2.x')
          .and_call_original
        expect(PluginSingleSource::Plugin::Release)
          .to receive(:new)
          .with(site:, version: '2.4.x', is_latest: false, plugin: subject, source: '_2.2.x')
          .and_call_original
        expect(PluginSingleSource::Plugin::Release)
          .to receive(:new)
          .with(site:, version: '2.3.x-EE', is_latest: false, plugin: subject, source: '_index')
          .and_call_original
        expect(PluginSingleSource::Plugin::Release)
          .to receive(:new)
          .with(site:, version: '2.3.x-CE', is_latest: false, plugin: subject, source: '_index')
          .and_call_original

        expect(subject.create_pages.size).to eq(31)
      end
    end
  end

  describe '#ext_data' do
    let(:name) { 'jwt-signer' }

    it 'includes the `strategy` present in the yaml file' do
      expect(subject.ext_data['strategy']).to eq('gateway')
    end

    it 'includes the `releases`' do
      expect(subject.ext_data['releases']).to eq([
        '2.8.x', '2.7.x', '2.6.x', '2.5.x', '2.4.x', '2.3.x-EE', '2.3.x-CE'
      ])
    end

    it 'includes the `overrides` listed in the yaml file' do
      expect(subject.ext_data['overrides']).to eq({
        '2.8.x' => '1.9.1',
        '2.7.x' => '1.9.0',
        '2.6.x' => '1.8.0',
        '2.5.x' => '1.7.0',
        '2.4.x' => '1.7.0',
        '2.3.x' => '1.7.0',
        '2.2.x' => '1.7.0',
        '2.1.x' => '1.7.0'
      })
    end
  end
end

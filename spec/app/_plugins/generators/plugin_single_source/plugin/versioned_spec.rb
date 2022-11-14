RSpec.describe PluginSingleSource::Plugin::Versioned do
  let(:dir) { [author, name].join('/') }
  let(:name) { 'jq' }
  let(:author) { 'acme' }

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
    context 'when `delegate_releases` is set to `true`' do
      let(:name) { 'jwt-signer' }

      it 'returns the versions defined in `kong_versions.yml`, replacements apply' do
        expect(subject.releases).to eq(
          ['3.0.x', '2.8.x', '2.7.x', '2.6.x', '2.5.x', '2.4.x', '2.3.x-EE', '2.3.x-CE', '2.2.x', '2.1.x']
        )
      end
    end

    context 'when it is not set or is set to `false`' do
      let(:name) { 'jq' }

      it 'returns the versions defined in the file, replacements do not apply' do
        expect(subject.releases).to eq(['3.0.x', '2.8.x', '2.7.x', '2.6.x'])
      end
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
      expect(PluginSingleSource::SingleSourcePage)
        .to receive(:new)
        .with(site:, version: '3.0.x', is_latest: true, plugin: subject, source: '_index')
        .and_call_original
      expect(PluginSingleSource::SingleSourcePage)
        .to receive(:new)
        .with(site:, version: '2.8.x', is_latest: false, plugin: subject, source: '_index')
        .and_call_original
      expect(PluginSingleSource::SingleSourcePage)
        .to receive(:new)
        .with(site:, version: '2.7.x', is_latest: false, plugin: subject, source: '_index')
        .and_call_original
      expect(PluginSingleSource::SingleSourcePage)
        .to receive(:new)
        .with(site:, version: '2.6.x', is_latest: false, plugin: subject, source: '_index')
        .and_call_original

      expect(subject.create_pages.size).to eq(4)
    end

    context 'when there is a file for a specific version or `source` present ' do
      let(:name) { 'jwt-signer' }

      it 'creates a page for each version of the plugin, except for those for which a .md file exist' do
        expect(PluginSingleSource::SingleSourcePage)
          .to receive(:new)
          .with(site:, version: '3.0.x', is_latest: true, plugin: subject, source: '_index')
          .and_call_original
        expect(PluginSingleSource::SingleSourcePage)
          .to receive(:new)
          .with(site:, version: '2.8.x', is_latest: false, plugin: subject, source: '_index')
          .and_call_original
        expect(PluginSingleSource::SingleSourcePage)
          .to receive(:new)
          .with(site:, version: '2.7.x', is_latest: false, plugin: subject, source: '_index')
          .and_call_original
        expect(PluginSingleSource::SingleSourcePage)
          .to receive(:new)
          .with(site:, version: '2.6.x', is_latest: false, plugin: subject, source: '_index')
          .and_call_original
        expect(PluginSingleSource::SingleSourcePage)
          .to receive(:new)
          .with(site:, version: '2.5.x', is_latest: false, plugin: subject, source: '_2.2.x')
          .and_call_original
        expect(PluginSingleSource::SingleSourcePage)
          .to receive(:new)
          .with(site:, version: '2.4.x', is_latest: false, plugin: subject, source: '_2.2.x')
          .and_call_original
        expect(PluginSingleSource::SingleSourcePage)
          .to receive(:new)
          .with(site:, version: '2.3.x-EE', is_latest: false, plugin: subject, source: '_index')
          .and_call_original
        expect(PluginSingleSource::SingleSourcePage)
          .to receive(:new)
          .with(site:, version: '2.3.x-CE', is_latest: false, plugin: subject, source: '_index')
          .and_call_original
        expect(PluginSingleSource::SingleSourcePage)
          .to receive(:new)
          .with(site:, version: '2.2.x', is_latest: false, plugin: subject, source: '_2.2.x')
          .and_call_original
        expect(PluginSingleSource::SingleSourcePage)
          .not_to receive(:new)
          .with(site:, version: '2.1.x', is_latest: false, plugin: subject, source: anything)
          .and_call_original

        expect(subject.create_pages.size).to eq(9)
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
        '3.0.x', '2.8.x', '2.7.x', '2.6.x', '2.5.x', '2.4.x', '2.3.x-EE', '2.3.x-CE', '2.2.x', '2.1.x'
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

RSpec.describe PluginSingleSource::Plugin::Versioned do
  let(:dir) { [author, name].join('/') }
  let(:name) { 'jq' }
  let(:author) { 'kong-inc' }

  subject { described_class.new(dir:, site:) }

  it_behaves_like 'a Plugin'

  describe '#extension?' do
    it { expect(subject.extension?).to eq(true) }
  end

  describe '#releases' do
    let(:name) { 'jwt-signer' }

    context 'when a `maximum_version` is set' do
      it 'returns the versions defined in `kong_versions.yml` in the `minimum_version` `maximum_version` range, replacements apply' do
        expect(subject.releases).to eq(
          ['2.8.x', '2.7.x', '2.6.x']
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
          ['3.0.x', '2.8.x', '2.7.x', '2.6.x']
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

  describe '#create_pages' do
    it 'creates a page for each version of the plugin' do
      expect(PluginSingleSource::Plugin::Release)
        .to receive(:new)
        .with(site:, version: '3.0.x', is_latest: true, plugin: subject)
        .and_call_original
      expect(PluginSingleSource::Plugin::Release)
        .to receive(:new)
        .with(site:, version: '2.8.x', is_latest: false, plugin: subject)
        .and_call_original
      expect(PluginSingleSource::Plugin::Release)
        .to receive(:new)
        .with(site:, version: '2.7.x', is_latest: false, plugin: subject)
        .and_call_original
      expect(PluginSingleSource::Plugin::Release)
        .to receive(:new)
        .with(site:, version: '2.6.x', is_latest: false, plugin: subject)
        .and_call_original

      expect(subject.create_pages.size).to eq(20)
    end
  end

  describe '#ext_data' do
    let(:name) { 'jwt-signer' }

    it 'includes the `strategy` present in the yaml file' do
      expect(subject.ext_data['strategy']).to eq('gateway')
    end

    it 'includes the `releases`' do
      expect(subject.ext_data['releases']).to eq([
        '2.8.x', '2.7.x', '2.6.x'
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

RSpec.describe PluginSingleSource::KongVersions do
  describe '.gateway' do
    let(:yaml) do
      <<~YAML
        -
          release: "3.0.x"
          ee-version: "3.0.1.0"
          ce-version: "3.0.1"
          edition: "gateway"
          luarocks_version: "3.0.0-0"
        -
          release: "1.16.x"
          version: "1.16.1"
          edition: "deck"
      YAML
    end

    before do
      allow(File).to receive(:read).and_call_original
      allow(File)
        .to receive(:read)
        .with(File.join(site.source, '_data/kong_versions.yml'))
        .and_return(yaml)
    end

    it 'returns the `release` for each gateway version and replaces `-x` with `x`' do
      expect(described_class.gateway(site)).to match_array(['3.0.x'])
    end
  end

  describe '.to_semver' do
    it 'replaces `x` and `-x` with 0s' do
      expect(described_class.to_semver('3.0.x')).to eq('3.0.0')
      expect(described_class.to_semver('3.x.x')).to eq('3.0.0')
      expect(described_class.to_semver('3.0.0-x')).to eq('3.0.0.0')
    end
  end
end

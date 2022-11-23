RSpec.describe PluginSingleSource::KongVersions do
  describe '.gateway' do
    let(:yaml) do
      <<~YAML
        - # Old OSS Gateway docs
          release: "2.1.x"
          version: "2.1.4"
          edition: "gateway-oss"
        - release: "2.2.x"
          version: "2.2.2"
          edition: "gateway-oss"
          luarocks_version: "2.2.2-0"
        - # Old Enterprise Gateway docs
          release: "2.1.0-x"
          version: "2.1.4.6"
          edition: "enterprise"
          luarocks_version: "0.34.x"
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
      expect(described_class.gateway(site)).to match_array(['2.1.x', '2.1.0.x', '2.2.x', '3.0.x'])
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

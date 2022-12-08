RSpec.describe PluginSingleSource::Generator do
  describe '#generate' do
    subject { described_class.new.generate(site) }

    it 'generates pages for each version of each plugin' do
      expect { subject }.to change { site.pages.size }.by(14)
    end

    it 'adds the latest version of the plugin to `data[sshg_hub]`' do
      subject

      expect(site.data['ssg_hub'].map(&:path)).to match_array([
        File.join(site.source, '_hub/acme/jq/_index.md'),
        File.join(site.source, '_hub/acme/jwt-signer/_index.md'),
        File.join(site.source, '_hub/acme/kong-plugin/_index.md'),
        File.join(site.source, '_hub/acme/unbundled-plugin/_index.md'),
      ])
    end

    it 'does not generate a page for the sample plugin' do
      allow(PluginSingleSource::Plugin::Base).to receive(:make_for).and_call_original

      subject

      expect(PluginSingleSource::Plugin::Base)
        .not_to have_received(:make_for).with(dir: '_init/my-extension', site:)
    end
  end
end

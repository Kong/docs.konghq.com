RSpec.describe PluginSingleSource::Generator do
  describe '#generate' do
    subject { described_class.new.generate(site) }

    it 'generates pages for each version of each plugin' do
      expect { subject }.to change { site.pages.size }.by(61)
    end

    it 'adds the latest version of the plugin to `data[sshg_hub]`' do
      subject

      expect(site.data['ssg_hub'].map(&:path)).to match_array([
        '_hub/kong-inc/jq/_index.md',
        '_hub/kong-inc/jwt-signer/_index.md',
        '_hub/acme/kong-plugin/_index.md',
        '_hub/acme/unbundled-plugin/_index.md',
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

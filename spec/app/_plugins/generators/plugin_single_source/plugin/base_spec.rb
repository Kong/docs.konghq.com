RSpec.describe PluginSingleSource::Plugin::Base do
  describe '.make_for' do
    subject { described_class.make_for(dir:, site:) }

    context 'a plugin with a `versions.yml`' do
      let(:dir) { 'kong-inc/jq' }

      it { expect(subject).to be_an_instance_of(PluginSingleSource::Plugin::Versioned) }
    end

    context 'a plugin without a `versions.yml`' do
      let(:dir) { 'acme/kong-plugin' }

      it { expect(subject).to be_an_instance_of(PluginSingleSource::Plugin::Unversioned) }
    end
  end
end

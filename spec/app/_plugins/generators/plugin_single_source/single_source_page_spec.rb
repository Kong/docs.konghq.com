RSpec.describe PluginSingleSource::SingleSourcePage do
  describe '#initialize' do
    let(:plugin) do
      PluginSingleSource::Plugin::Base.make_for(dir: 'acme/jwt-signer', site:)
    end

    subject { described_class.new(site:, version:, plugin:, is_latest:, source:) }

    context 'when the `source` does not start with `_`' do
      let(:source) { 'index' }
      let(:version) { '3.0.x' }
      let(:is_latest) { true }

      it 'raises an expection' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'when it is the latest version of the plugin' do
      let(:source) { '_index' }
      let(:version) { '3.0.x' }
      let(:is_latest) { true }

      it 'sets the corresponding attributes' do
        expect(subject.instance_variable_get(:@path)).to eq(File.expand_path('_hub/acme/jwt-signer/index.md', site.source))
        expect(subject.instance_variable_get(:@dir)).to eq('hub/acme/jwt-signer')
        expect(subject.data['version']).to eq('3.0.x')
        expect(subject.data['is_latest']).to eq(true)
        expect(subject.data['canonical_url']).to be_nil
        expect(subject.data['seo_noindex']).to be_nil
        expect(subject.data['path']).to eq('_hub/acme/jwt-signer/index.md')
        expect(subject.data['permalink']).to eq('hub/acme/jwt-signer/')
        expect(subject.data['layout']).to eq('extension')
      end
    end

    context 'when it is not' do
      let(:source) { '_index' }
      let(:version) { '2.8.x' }
      let(:is_latest) { false }

      it 'sets the corresponding attributes' do
        expect(subject.instance_variable_get(:@path)).to eq(File.expand_path('_hub/acme/jwt-signer/2.8.x.md', site.source))
        expect(subject.instance_variable_get(:@dir)).to eq('hub/acme/jwt-signer')
        expect(subject.data['version']).to eq('2.8.x')
        expect(subject.data['is_latest']).to eq(false)
        expect(subject.data['canonical_url']).to eq('/hub/acme/jwt-signer/')
        expect(subject.data['seo_noindex']).to eq(true)
        expect(subject.data['path']).to eq('_hub/acme/jwt-signer/2.8.x.md')
        expect(subject.data['permalink']).to eq('hub/acme/jwt-signer/2.8.x.html')
        expect(subject.data['layout']).to eq('extension')
      end
    end
  end
end

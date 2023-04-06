RSpec.describe PluginSingleSource::Pages::Reference do
  let(:plugin) { PluginSingleSource::Plugin::Base.make_for(dir: 'kong-inc/jwt-signer', site:) }
  let(:release) { PluginSingleSource::Plugin::Release.new(site:, version:, plugin:, is_latest:, source:) }

  subject { described_class.new(release:, file: nil, source_path:) }

  describe '#data' do
    before do
      expect(PluginSingleSource::Plugin::PageData).to receive(:generate).and_call_original
    end

    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }
      let(:source_path) { File.expand_path("_hub/kong-inc/jwt-signer/#{source}/", site.source) }

      it 'returns a hash containing the data needed to render the templates' do
        expect(subject.data).to include({
          'canonical_url' => '/hub/kong-inc/jwt-signer/reference/',
          'source_file' => nil,
          'permalink' => '/hub/kong-inc/jwt-signer/2.5.x/reference.html',
          'ssg_hub' => false,
          'title' => 'Kong JWT Signer plugin reference'
        })
      end
    end

    context 'when using `_index.md`' do
      let(:is_latest) { true }
      let(:version) { '2.8.x' }
      let(:source) { '_index' }
      let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

      it 'returns a hash containing the data needed to render the templates' do
        expect(subject.data).to include({
          'canonical_url' => nil,
          'source_file' => nil,
          'permalink' => '/hub/kong-inc/jwt-signer/reference/',
          'ssg_hub' => false,
          'title' => 'Kong JWT Signer plugin reference'
        })
      end
    end
  end

  describe '#source_file' do
    let(:is_latest) { true }
    let(:source) { '_index' }
    let(:version) { '2.8.x' }
    let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

    it { expect(subject.source_file).to be_nil }
  end
end

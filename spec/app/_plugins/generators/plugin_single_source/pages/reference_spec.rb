RSpec.describe PluginSingleSource::Pages::Reference do
  let(:plugin) { PluginSingleSource::Plugin::Base.make_for(dir: 'acme/jwt-signer', site:) }
  let(:release) { PluginSingleSource::Plugin::Release.new(site:, version:, plugin:, is_latest:, source:) }

  subject { described_class.new(release:, file:, source_path:) }

  describe '#content' do
    let(:file) { 'reference/_index.md' }
    let(:content) { markdown_content(File.expand_path(file, source_path)) }

    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }
      let(:source_path) { File.expand_path("_hub/acme/jwt-signer/#{source}/", site.source) }

      it 'returns the content of the corresponding reference/_index.md' do
        expect(subject.content).to eq(content)
      end
    end

    context 'when using `_index.md`' do
      let(:is_latest) { true }
      let(:source) { '_index' }
      let(:version) { '2.8.x' }
      let(:source_path) { File.expand_path('_hub/acme/jwt-signer/', site.source) }

      it 'returns the content of the corresponding reference/_index.md' do
        expect(subject.content).to eq(content)
      end
    end
  end

  describe '#data' do
    let(:file) { 'reference/_index.md' }
    before do
      expect(PluginSingleSource::Plugin::PageData).to receive(:generate).and_call_original
    end

    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }
      let(:source_path) { File.expand_path("_hub/acme/jwt-signer/#{source}/", site.source) }

      it 'returns a hash containing the data needed to render the templates' do
        expect(subject.data).to include({
          'canonical_url' => '/hub/acme/jwt-signer/reference/',
          'source_file' => '_hub/acme/jwt-signer/_2.2.x/reference/_index.md',
          'permalink' => '/hub/acme/jwt-signer/2.5.x/reference.html',
          'ssg_hub' => false,
          'title' => 'Kong JWT Signer plugin reference'
        })
      end
    end

    context 'when using `_index.md`' do
      let(:is_latest) { true }
      let(:version) { '2.8.x' }
      let(:source) { '_index' }
      let(:source_path) { File.expand_path('_hub/acme/jwt-signer/', site.source) }

      it 'returns a hash containing the data needed to render the templates' do
        expect(subject.data).to include({
          'canonical_url' => nil,
          'source_file' => '_hub/acme/jwt-signer/reference/_index.md',
          'permalink' => '/hub/acme/jwt-signer/reference/',
          'ssg_hub' => false,
          'title' => 'Kong JWT Signer plugin reference'
        })
      end
    end
  end

  describe '#source_file' do
    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }
      let(:file) { 'reference/_index.md' }
      let(:source_path) { File.expand_path("_hub/acme/jwt-signer/#{source}/", site.source) }

      it 'returns the relative path to the file inside the corresponding folder' do
        expect(subject.source_file).to eq('_hub/acme/jwt-signer/_2.2.x/reference/_index.md')
      end
    end

    context 'when using `_index.md`' do
      let(:is_latest) { true }
      let(:source) { '_index' }
      let(:version) { '2.8.x' }
      let(:file) { 'reference/_index.md' }
      let(:source_path) { File.expand_path('_hub/acme/jwt-signer/', site.source) }

      it 'returns the relative path to the file inside the corresponding folder' do
        expect(subject.source_file).to eq('_hub/acme/jwt-signer/reference/_index.md')
      end
    end
  end
end

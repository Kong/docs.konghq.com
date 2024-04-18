RSpec.describe PluginSingleSource::Pages::HowTo do
  let(:plugin) { PluginSingleSource::Plugin::Base.make_for(dir: 'kong-inc/jwt-signer', site:) }
  let(:release) { PluginSingleSource::Plugin::Release.new(site:, version:, plugin:, is_latest:) }

  subject { described_class.new(release:, file:, source_path:) }

  describe '#content' do
    let(:content) { markdown_content(File.expand_path(file, source_path)) }
    let(:is_latest) { true }
    let(:version) { '2.8.x' }
    let(:file) { 'how-to/_index.md' }
    let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

    it 'returns the content of the corresponding how-to/_index.md' do
      expect(subject.content).to eq(content)
    end

    context 'nested files' do
      let(:file) { 'how-to/nested/_tutorial.md' }

      it 'returns the content of the corresponding how-to/ file' do
        expect(subject.content).to eq(content)
      end
    end
  end

  describe '#data' do
    let(:is_latest) { true }
    let(:version) { '2.8.x' }
    let(:file) { 'how-to/_index.md' }
    let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

    before do
      expect(PluginSingleSource::Plugin::PageData).to receive(:generate).and_call_original
    end

    it 'returns a hash containing the data needed to render the templates' do
      expect(subject.data).to include({
        'canonical_url' => '/hub/kong-inc/jwt-signer/how-to/',
        'source_file' => '_hub/kong-inc/jwt-signer/how-to/_index.md',
        'permalink' => '/hub/kong-inc/jwt-signer/how-to/',
        'ssg_hub' => false,
        'title' => 'Using the Kong JWT Signer plugin'
      })
    end
  end

  describe '#source_file' do
    let(:is_latest) { true }
    let(:version) { '2.8.x' }
    let(:file) { 'how-to/_index.md' }
    let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

    it 'returns the relative path to the file inside the corresponding folder' do
      expect(subject.source_file).to eq('_hub/kong-inc/jwt-signer/how-to/_index.md')
    end

    context 'nested files' do
      let(:file) { 'how-to/nested/_tutorial.md' }

      it 'returns the relative path to the file inside the corresponding folder' do
        expect(subject.source_file).to eq('_hub/kong-inc/jwt-signer/how-to/nested/_tutorial.md')
      end
    end
  end

  describe '#breadcrumbs' do
    context 'when _index.md exists' do
      let(:is_latest) { true }
      let(:version) { '2.8.x' }
      let(:file) { 'how-to/nested/_tutorial.md' }
      let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

      it 'returns a hash containing the page\'s breadcrumbs' do
        expect(subject.breadcrumbs).to eq([
          { text: 'Authentication', url: '/hub/?category=authentication' },
          { text: 'Kong JWT Signer', url: '/hub/kong-inc/jwt-signer/' },
          { text: 'How to', url: '/hub/kong-inc/jwt-signer/how-to/' },
          { text: 'Nested Tutorial Nav title', url: '/hub/kong-inc/jwt-signer/how-to/nested/tutorial/' }
        ])
      end

      context 'for older versions' do
        let(:is_latest) { false }
        let(:version) { '2.6.x' }
        let(:source_path) { File.expand_path("_hub/kong-inc/jwt-signer/", site.source) }

        it 'returns a hash containing the page\'s breadcrumbs' do
          expect(subject.breadcrumbs).to eq([
            { text: 'Authentication', url: '/hub/?category=authentication' },
            { text: 'Kong JWT Signer', url: '/hub/kong-inc/jwt-signer/2.6.x/' },
            { text: 'How to', url: '/hub/kong-inc/jwt-signer/2.6.x/how-to/' },
            { text: 'Nested Tutorial Nav title', url: '/hub/kong-inc/jwt-signer/2.6.x/how-to/nested/tutorial/' }
          ])
        end
      end
    end
  end
end

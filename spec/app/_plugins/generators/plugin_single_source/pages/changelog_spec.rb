RSpec.describe PluginSingleSource::Pages::Changelog do
  let(:file) { '_changelog.md' }
  let(:plugin) { PluginSingleSource::Plugin::Base.make_for(dir: 'kong-inc/jwt-signer', site:) }
  let(:release) { PluginSingleSource::Plugin::Release.new(site:, version:, plugin:, is_latest:) }
  let(:source_path) { File.expand_path("_hub/kong-inc/jwt-signer/", site.source) }

  subject { described_class.new(release:, file:, source_path:) }

  describe '#content' do
    let(:content) { markdown_content(File.expand_path('_hub/kong-inc/jwt-signer/_changelog.md', site.source)) }
    let(:is_latest) { true }
    let(:version) { '2.8.x' }

    it 'returns the content of the `_changelog.md` file at the top level' do
      expect(subject.content).to eq(content)
    end
  end

  describe '#data' do
    before do
      expect(PluginSingleSource::Plugin::PageData).to receive(:generate).and_call_original
    end

    context 'when it is the latest version of the plugin' do
      let(:is_latest) { true }
      let(:version) { '2.8.x' }

      it 'returns a hash containing the data needed to render the templates' do
        expect(subject.data).to include({
          'canonical_url' => '/hub/kong-inc/jwt-signer/changelog/',
          'source_file' => '_hub/kong-inc/jwt-signer/_changelog.md',
          'permalink' => '/hub/kong-inc/jwt-signer/changelog/',
          'ssg_hub' => false,
          'title' => 'Kong JWT Signer Changelog'
        })
      end
    end

    context 'when it is not the latest version of the plugin' do
      let(:is_latest) { false }
      let(:version) { '2.6.x' }

      it 'returns a hash containing the data needed to render the templates' do
        expect(subject.data).to include({
          'canonical_url' => '/hub/kong-inc/jwt-signer/changelog/',
          'source_file' => '_hub/kong-inc/jwt-signer/_changelog.md',
          'permalink' => '/hub/kong-inc/jwt-signer/2.6.x/changelog/',
          'ssg_hub' => false,
          'title' => 'Kong JWT Signer Changelog'
        })
      end
    end
  end

  describe '#source_file' do
    let(:is_latest) { true }
    let(:version) { '2.8.x' }

    it 'returns the relative path to the top-level _index.md file' do
      expect(subject.source_file).to eq('_hub/kong-inc/jwt-signer/_changelog.md')
    end
  end

  describe '#breadcrumbs' do
    let(:is_latest) { true }
    let(:version) { '2.8.x' }

    it 'returns a hash containing the page\'s breadcrumbs' do
      expect(subject.breadcrumbs).to eq([
        { text: 'Authentication', url: '/hub/?category=authentication' },
        { text: 'Kong JWT Signer', url: '/hub/kong-inc/jwt-signer/' },
        { text: 'Changelog', url: '/hub/kong-inc/jwt-signer/changelog/' }
      ])
    end
  end
end

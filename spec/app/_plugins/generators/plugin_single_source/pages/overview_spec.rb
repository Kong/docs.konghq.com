RSpec.describe PluginSingleSource::Pages::Overview do
  let(:file) { 'overview/_index.md' }
  let(:plugin) { PluginSingleSource::Plugin::Base.make_for(dir: 'kong-inc/jwt-signer', site:) }
  let(:release) { PluginSingleSource::Plugin::Release.new(site:, version:, plugin:, is_latest:, source:) }

  subject { described_class.new(release:, file:, source_path:) }

  describe '#content' do
    let(:index_file_path) { File.expand_path('overview/_index.md', source_path) }
    let(:index) { markdown_content(File.expand_path(index_file_path, site.source)) }

    shared_examples_for 'returns the content of _index.md' do
      it { expect(subject.content).to include(index) }
    end

    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.6.x' }
      let(:source) { '_2.6.x' }
      let(:source_path) { File.expand_path("_hub/kong-inc/jwt-signer/#{source}/", site.source) }

      it_behaves_like 'returns the content of _index.md'
    end

    context 'when using `_index.md`' do
      let(:is_latest) { true }
      let(:source) { '_index' }
      let(:version) { '2.8.x' }
      let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }
      it_behaves_like 'returns the content of _index.md'
    end
  end

  describe '#data' do
    before do
      expect(PluginSingleSource::Plugin::PageData).to receive(:generate).and_call_original
    end

    context 'when it is the latest version of the plugin' do
      let(:is_latest) { true }
      let(:version) { '2.8.x' }
      let(:source) { '_index' }
      let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

      it 'returns a hash containing the data needed to render the templates' do
        expect(subject.data).to include({
          'canonical_url' => '/hub/kong-inc/jwt-signer/',
          'source_file' => '_hub/kong-inc/jwt-signer/overview/_index.md',
          'permalink' => '/hub/kong-inc/jwt-signer/',
          'ssg_hub' => true,
          'title' => 'Kong JWT Signer'
        })
      end

      context 'nested file' do
        let(:file) { 'overview/_nested.md'}

        it 'returns a hash containing the data needed to render the templates' do
          expect(subject.data).to include({
            'canonical_url' => '/hub/kong-inc/jwt-signer/nested/',
            'source_file' => '_hub/kong-inc/jwt-signer/overview/_nested.md',
            'permalink' => '/hub/kong-inc/jwt-signer/nested/',
            'ssg_hub' => false,
            'title' => 'Kong JWT Signer'
          })
        end
      end
    end

    context 'when it is not the latest version of the plugin' do
      let(:is_latest) { false }
      let(:version) { '2.6.x' }
      let(:source) { '_2.6.x' }
      let(:source_path) { File.expand_path("_hub/kong-inc/jwt-signer/#{source}/", site.source) }

      it 'returns a hash containing the data needed to render the templates' do
        expect(subject.data).to include({
          'canonical_url' => '/hub/kong-inc/jwt-signer/',
          'source_file' => '_hub/kong-inc/jwt-signer/_2.6.x/overview/_index.md',
          'permalink' => '/hub/kong-inc/jwt-signer/2.6.x/',
          'ssg_hub' => false,
          'title' => 'Kong JWT Signer'
        })
      end
    end

    context 'when the page has frontmatter' do
      let(:is_latest) { true }
      let(:version) { '2.8.x' }
      let(:source) { '_index' }
      let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

      it 'includes makes the content available on the page' do
        expect(subject.data.fetch('frontmatter_attr')).to eq('Metadata defined in frontmatter')
      end
    end
  end

  describe '#source_file' do
    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }
      let(:source_path) { File.expand_path("_hub/kong-inc/jwt-signer/#{source}/", site.source) }

      it 'returns the relative path to the _index.md file inside the corresponding folder' do
        expect(subject.source_file).to eq('_hub/kong-inc/jwt-signer/_2.2.x/overview/_index.md')
      end
    end

    context 'when using `_index.md`' do
      let(:is_latest) { true }
      let(:version) { '2.8.x' }
      let(:source) { '_index' }
      let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

      it 'returns the relative path to the top-level _index.md file' do
        expect(subject.source_file).to eq('_hub/kong-inc/jwt-signer/overview/_index.md')
      end
    end
  end

  describe '#breadcrumbs' do
    let(:is_latest) { true }
    let(:version) { '2.8.x' }
    let(:source) { '_index' }
    let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

    it 'returns a hash containing the page\'s breadcrumbs' do
      expect(subject.breadcrumbs).to eq([
        { text: 'Authentication', url: '/hub/?category=authentication' },
        { text: 'Kong JWT Signer', url: '/hub/kong-inc/jwt-signer/' },
        { text: 'Introduction' },
        { text: 'Overview', url: '/hub/kong-inc/jwt-signer/' },
      ])
    end

    context 'nested file' do
      let(:file) { 'overview/_nested.md' }

      it 'returns a hash containing the page\'s breadcrumbs' do
        expect(subject.breadcrumbs).to eq([
          { text: 'Authentication', url: '/hub/?category=authentication' },
          { text: 'Kong JWT Signer', url: '/hub/kong-inc/jwt-signer/' },
          { text: 'Introduction' },
          { text: 'Nested file', url: '/hub/kong-inc/jwt-signer/nested/' },
        ])
      end

      context 'old version' do
        let(:is_latest) { false }
        let(:version) { '2.7.x' }

        it 'returns a hash containing the page\'s breadcrumbs' do
          expect(subject.breadcrumbs).to eq([
            { text: 'Authentication', url: '/hub/?category=authentication' },
            { text: 'Kong JWT Signer', url: '/hub/kong-inc/jwt-signer/2.7.x/' },
            { text: 'Introduction' },
            { text: 'Nested file', url: '/hub/kong-inc/jwt-signer/2.7.x/nested/' },
          ])
        end
      end
    end
  end
end

RSpec.describe PluginSingleSource::Pages::Overview do
  let(:file) { '_index.md' }
  let(:plugin) { PluginSingleSource::Plugin::Base.make_for(dir: 'kong-inc/jwt-signer', site:) }
  let(:release) { PluginSingleSource::Plugin::Release.new(site:, version:, plugin:, is_latest:, source:) }

  subject { described_class.new(release:, file:, source_path:) }

  describe '#content' do
    let(:changelog) { markdown_content(File.expand_path('_hub/kong-inc/jwt-signer/_changelog.md', site.source)) }
    let(:how_to) { markdown_content(File.expand_path(how_to_file_path, site.source)) }
    let(:reference) { markdown_content(File.expand_path(reference_file_path, site.source)) }

    shared_examples_for 'returns the content of the corresponding how-to/_index.md, reference/_index.md and _changelog.md' do
      it do
        expect(subject.content).to include(how_to)
        expect(subject.content).to include(reference)
        expect(subject.content).to include(changelog)
      end
    end

    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }
      let(:how_to_file_path) { '_hub/kong-inc/jwt-signer/_2.2.x/how-to/_index.md' }
      let(:reference_file_path) { '_hub/kong-inc/jwt-signer/_2.2.x/reference/_index.md' }
      let(:source_path) { File.expand_path("_hub/kong-inc/jwt-signer/#{source}/", site.source) }

      it_behaves_like 'returns the content of the corresponding how-to/_index.md, reference/_index.md and _changelog.md'
    end

    context 'when using `_index.md`' do
      let(:is_latest) { true }
      let(:source) { '_index' }
      let(:version) { '2.8.x' }
      let(:how_to_file_path) { '_hub/kong-inc/jwt-signer/how-to/_index.md' }
      let(:reference_file_path) { '_hub/kong-inc/jwt-signer/reference/_index.md' }
      let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }
      it_behaves_like 'returns the content of the corresponding how-to/_index.md, reference/_index.md and _changelog.md'
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
          'canonical_url' => nil,
          'source_file' => '_hub/kong-inc/jwt-signer/_index.md',
          'permalink' => '/hub/kong-inc/jwt-signer/',
          'ssg_hub' => true,
          'title' => 'Kong JWT Signer Overview'
        })
      end
    end

    context 'when it is not the latest version of the plugin' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }
      let(:source_path) { File.expand_path("_hub/kong-inc/jwt-signer/#{source}/", site.source) }

      it 'returns a hash containing the data needed to render the templates' do
        expect(subject.data).to include({
          'canonical_url' => '/hub/kong-inc/jwt-signer/',
          'source_file' => '_hub/kong-inc/jwt-signer/_2.2.x/_index.md',
          'permalink' => '/hub/kong-inc/jwt-signer/2.5.x.html',
          'ssg_hub' => false,
          'title' => 'Kong JWT Signer Overview'
        })
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
        expect(subject.source_file).to eq('_hub/kong-inc/jwt-signer/_2.2.x/_index.md')
      end
    end

    context 'when using `_index.md`' do
      let(:is_latest) { true }
      let(:version) { '2.8.x' }
      let(:source) { '_index' }
      let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

      it 'returns the relative path to the top-level _index.md file' do
        expect(subject.source_file).to eq('_hub/kong-inc/jwt-signer/_index.md')
      end
    end
  end
end

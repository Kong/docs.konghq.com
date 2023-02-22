RSpec.describe PluginSingleSource::Pages::Changelog do
  let(:file) { '_changelog.md' }
  let(:plugin) { PluginSingleSource::Plugin::Base.make_for(dir: 'acme/jwt-signer', site:) }
  let(:release) { PluginSingleSource::Plugin::Release.new(site:, version:, plugin:, is_latest:, source:) }
  let(:source_path) { File.expand_path("_hub/acme/jwt-signer/", site.source) }

  subject { described_class.new(release:, file:, source_path:) }

  describe '#content' do
    shared_examples_for 'returns the content of the `_changelog.md` file at the top level' do
      let(:content) { markdown_content(File.expand_path('_hub/acme/jwt-signer/_changelog.md', site.source)) }
      it { expect(subject.content).to eq(content) }
    end

    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }
      it_behaves_like 'returns the content of the `_changelog.md` file at the top level'
    end

    context 'when using `_index.md`' do
      let(:is_latest) { true }
      let(:version) { '2.8.x' }
      let(:source) { '_index.md' }
      it_behaves_like 'returns the content of the `_changelog.md` file at the top level'
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

      it 'returns a hash containing the data needed to render the templates' do
        expect(subject.data).to include({
          'canonical_url' => nil,
          'source_file' => '_hub/acme/jwt-signer/_changelog.md',
          'permalink' => 'hub/acme/jwt-signer/changelog/',
          'ssg_hub' => false,
          'title' => 'Kong JWT Signer Changelog'
        })
      end
    end

    context 'when it is not the latest version of the plugin' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }

      it 'returns a hash containing the data needed to render the templates' do
        expect(subject.data).to include({
          'canonical_url' => '/hub/acme/jwt-signer/changelog/',
          'source_file' => '_hub/acme/jwt-signer/_changelog.md',
          'permalink' => 'hub/acme/jwt-signer/2.5.x/changelog.html',
          'ssg_hub' => false,
          'title' => 'Kong JWT Signer Changelog'
        })
      end
    end
  end

  describe '#source_file' do
    shared_examples_for 'returns the relative path to the top-level _index.md file' do
      it { expect(subject.source_file).to eq('_hub/acme/jwt-signer/_changelog.md') }
    end

    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }

      it_behaves_like 'returns the relative path to the top-level _index.md file'
    end

    context 'when using `_index.md`' do
      let(:is_latest) { true }
      let(:version) { '2.8.x' }
      let(:source) { '_index' }

      it_behaves_like 'returns the relative path to the top-level _index.md file'
    end
  end
end

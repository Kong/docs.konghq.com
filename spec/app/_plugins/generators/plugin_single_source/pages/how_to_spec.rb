RSpec.describe PluginSingleSource::Pages::HowTo do
  let(:plugin) { PluginSingleSource::Plugin::Base.make_for(dir: 'kong-inc/jwt-signer', site:) }
  let(:release) { PluginSingleSource::Plugin::Release.new(site:, version:, plugin:, is_latest:, source:) }

  subject { described_class.new(release:, file:, source_path:) }

  describe '#content' do
    let(:content) { markdown_content(File.expand_path(file, source_path)) }

    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }
      let(:file) { 'how-to/_index.md' }
      let(:source_path) { File.expand_path("_hub/kong-inc/jwt-signer/#{source}/", site.source) }

      it 'returns the content of the corresponding how-to/_index.md' do
        expect(subject.content).to eq(content)
      end
    end

    context 'when using `_index.md`' do
      let(:is_latest) { true }
      let(:source) { '_index' }
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
  end

  describe '#data' do
    before do
      expect(PluginSingleSource::Plugin::PageData).to receive(:generate).and_call_original
    end

    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }
      let(:file) { 'how-to/_index.md' }
      let(:source_path) { File.expand_path("_hub/kong-inc/jwt-signer/#{source}/", site.source) }

      it 'returns a hash containing the data needed to render the templates' do
        expect(subject.data).to include({
          'canonical_url' => '/hub/kong-inc/jwt-signer/how-to/',
          'source_file' => '_hub/kong-inc/jwt-signer/_2.2.x/how-to/_index.md',
          'permalink' => '/hub/kong-inc/jwt-signer/2.5.x/how-to/',
          'ssg_hub' => false,
          'title' => 'Using the Kong JWT Signer plugin'
        })
      end

      context 'nested file' do
        let(:file) { 'how-to/nested/_tutorial.md' }

        it 'returns a hash containing the data needed to render the templates' do
          expect(subject.data).to include({
            'canonical_url' => '/hub/kong-inc/jwt-signer/how-to/nested/tutorial/',
            'source_file' => '_hub/kong-inc/jwt-signer/_2.2.x/how-to/nested/_tutorial.md',
            'permalink' => '/hub/kong-inc/jwt-signer/2.5.x/how-to/nested/tutorial/',
            'ssg_hub' => false,
            'title' => 'Using the Kong JWT Signer plugin'
          })
        end
      end
    end

    context 'when using `_index.md`' do
      let(:is_latest) { true }
      let(:source) { '_index' }
      let(:version) { '2.8.x' }
      let(:file) { 'how-to/_index.md' }
      let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }

      it 'returns a hash containing the data needed to render the templates' do
        expect(subject.data).to include({
          'canonical_url' => nil,
          'source_file' => '_hub/kong-inc/jwt-signer/how-to/_index.md',
          'permalink' => '/hub/kong-inc/jwt-signer/how-to/',
          'ssg_hub' => false,
          'title' => 'Using the Kong JWT Signer plugin'
        })
      end
    end
  end

  describe '#source_file' do
    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }
      let(:file) { 'how-to/_index.md' }
      let(:source_path) { File.expand_path("_hub/kong-inc/jwt-signer/#{source}/", site.source) }

      it 'returns the relative path to the file inside the corresponding folder' do
        expect(subject.source_file).to eq('_hub/kong-inc/jwt-signer/_2.2.x/how-to/_index.md')
      end
    end

    context 'when using `_index.md`' do
      let(:is_latest) { true }
      let(:source) { '_index' }
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
  end
end

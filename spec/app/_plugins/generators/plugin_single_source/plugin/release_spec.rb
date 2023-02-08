RSpec.describe PluginSingleSource::Plugin::Release do
  let(:plugin_name) { 'acme/jwt-signer' }
  let(:is_latest) { true }
  let(:source) { '_index' }
  let(:version) { '2.8.x' }
  let(:plugin) do
    PluginSingleSource::Plugin::Base.make_for(dir: plugin_name, site:)
  end

  subject { described_class.new(site:, version:, plugin:, is_latest:, source:) }

  describe '#configuration_parameters_table' do
    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }

      it 'returns the content of the _configuration.yml inside the corresponding folder' do
        expect(subject.configuration_parameters_table)
          .to eq(SafeYAML.load(File.read(File.expand_path('_hub/acme/jwt-signer/_2.2.x/_configuration.yml', site.source))))
      end
    end

    context 'when using `_index.md`' do
      it 'returns the content of the _configuration.yml at the top level' do
        expect(subject.configuration_parameters_table)
          .to eq(SafeYAML.load(File.read(File.expand_path('_hub/acme/jwt-signer/_configuration.yml', site.source))))
      end
    end
  end

  describe '#changelog' do
    shared_examples_for 'returns the content of the `_changelog.md` file at the top level' do
      it do
        expect(subject.changelog)
          .to eq(File.read(File.expand_path('_hub/acme/jwt-signer/_changelog.md', site.source)))
      end
    end

    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }

      it_behaves_like 'returns the content of the `_changelog.md` file at the top level'
    end

    context 'when using `_index.md`' do
      it_behaves_like 'returns the content of the `_changelog.md` file at the top level'
    end
  end

  describe '#how_to' do
    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }

      it 'returns the content of the <version>/how-to/_index.md file' do
        expect(subject.how_to).to eq(
        <<~CONTENT
          ## _2.2.x Description

          content: Verify and (re-)sign one or two tokens in a request
        CONTENT
        )
      end
    end

    context 'when using `_index.md`' do
      it 'returns the content of the how-to/_index.md file' do
        expect(subject.how_to).to eq(
          File.read(File.expand_path('_hub/acme/jwt-signer/how-to/_index.md', site.source))
        )
      end
    end
  end

  describe '#frontmatter' do
    let(:frontmatter) do
      SafeYAML.load(
        File.read(File.expand_path(file_path, site.source)).match(/---\n(.*)\n---/m)[1]
      )
    end

    shared_examples_for 'returns the frontmatter section of the file parsed as yaml' do
      it { expect(subject.frontmatter).to eq(frontmatter) }
    end

    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }
      let(:file_path) { '_hub/acme/jwt-signer/_2.2.x/_index.md' }

      it_behaves_like 'returns the frontmatter section of the file parsed as yaml'
    end

    context 'when using `_index.md`' do
      let(:file_path) { '_hub/acme/jwt-signer/_index.md' }
      it_behaves_like 'returns the frontmatter section of the file parsed as yaml'
    end
  end

  describe '#content' do
    let(:changelog) do
      File.read(File.expand_path('_hub/acme/jwt-signer/_changelog.md', site.source))
    end
    let(:markdown) do
      File.read(File.expand_path(file_path, site.source))
    end

    shared_examples_for 'returns the content of the corresponding how-to/_index.md and _changelog.md' do
      it do
        expect(subject.content).to include(markdown)
        expect(subject.content).to include(changelog)
      end
    end

    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }
      let(:file_path) { '_hub/acme/jwt-signer/_2.2.x/how-to/_index.md' }

      it_behaves_like 'returns the content of the corresponding how-to/_index.md and _changelog.md'
    end

    context 'when using `_index.md`' do
      let(:file_path) { '_hub/acme/jwt-signer/how-to/_index.md' }
      it_behaves_like 'returns the content of the corresponding how-to/_index.md and _changelog.md'
    end
  end

  describe '#latest?' do
    it { expect(subject.latest?).to eq(is_latest) }
  end


  describe '#data' do
    it 'returns a hash containing the data needed to render the templates' do
      expect(PluginSingleSource::Plugin::PageData).to receive(:generate).and_call_original
      expect(subject.data).to be_a(Hash)
    end
  end

  describe '#source_file' do
    context 'when there is a specific folder for the version' do
      let(:is_latest) { false }
      let(:version) { '2.5.x' }
      let(:source) { '_2.2.x' }

      it 'returns the relative path to the _index.md file inside the corresponding folder' do
        expect(subject.source_file).to eq('_hub/acme/jwt-signer/_2.2.x/_index.md')
      end
    end

    context 'when using `_index.md`' do
      it 'returns the relative path to the top-level _index.md file' do
        expect(subject.source_file).to eq('_hub/acme/jwt-signer/_index.md')
      end
    end
  end
end

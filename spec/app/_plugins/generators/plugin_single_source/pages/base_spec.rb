RSpec.describe PluginSingleSource::Pages::Base do
  let(:file) { 'overview/_index.md' }
  let(:plugin) { PluginSingleSource::Plugin::Base.make_for(dir: 'kong-inc/jwt-signer', site:) }
  let(:release) { PluginSingleSource::Plugin::Release.new(site:, version:, plugin:, is_latest: true) }
  let(:source_path) { File.expand_path('_hub/kong-inc/jwt-signer/', site.source) }
  let(:version) { '2.8.x' }

  describe '#generate?' do
    subject { described_class.new(release:, file:, source_path:) }

    context 'when the doc does not have minimum_version and maximum_version set' do
      before { allow(subject).to receive(:frontmatter_attributes).and_return({}) }

      it { expect(subject.generate?).to be_truthy }
    end

    context 'when the doc have both minimum_version and maximum_version set' do
      before do
        allow(subject)
          .to receive(:frontmatter_attributes)
          .and_return({ 'minimum_version' => '2.8.x', 'maximum_version' => '3.0.x' })
      end

      context 'when the page\'s version is in range' do
        let(:version) { '2.8.x' }

        it { expect(subject.generate?).to be_truthy }
      end

      context 'when the page\'s version is not in range' do
        let(:version) { '2.6.x' }

        it { expect(subject.generate?).to be_falsey }
      end
    end

    context 'when only one limit is set' do
      context 'minimum_version' do
        before do
          allow(subject)
            .to receive(:frontmatter_attributes)
            .and_return({ 'minimum_version' => '2.8.x' })
        end

        context 'when the page\'s version is in the range' do
          let(:version) { '2.9.x' }

          it { expect(subject.generate?).to be_truthy }
        end

        context 'when the page\'s version is not in the range' do
          let(:version) { '2.6.x' }

          it { expect(subject.generate?).to be_falsey }
        end
      end

      context 'maximum_version' do
        before do
          allow(subject)
            .to receive(:frontmatter_attributes)
            .and_return({ 'maximum_version' => '2.8.x' })
        end

        context 'when the page\'s version is in the range' do
          let(:version) { '2.8.x' }

          it { expect(subject.generate?).to be_truthy }
        end

        context 'when the page\'s version is not in the range' do
          let(:version) { '3.0.x' }

          it { expect(subject.generate?).to be_falsey }
        end
      end
    end
  end

  describe '.make_for' do
    let(:file) { 'how-to/nested/_tutorial-with-min-and-max.md' }

    subject { described_class.make_for(release:, file:, source_path:) }

    context 'when the page\'s version is not in the defined range' do
      let(:version) { '2.6.x' }

      it { expect(subject).to be_nil }
    end

    context 'when the page\'s version is in the range' do
      let(:version) { '2.8.x' }

      it { expect(subject).to be_an_instance_of(PluginSingleSource::Pages::Base) }
    end
  end
end

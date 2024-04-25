RSpec.describe Jekyll::Drops::Plugins::Example do
  let(:type) { 'consumer' }
  let(:schema) do
    PluginSingleSource::Plugin::Schemas::Kong.new(
      plugin_name: 'opentelemetry',
      vendor: 'kong-inc',
      version: '3.2.x',
      site:
    )
  end
  let(:example) { schema.example }
  let(:formats) { [:curl, :konnect, :yaml, :kubernetes] }

  subject { described_class.new(type:, example:, formats:) }

  describe '#type' do
    it { expect(subject.type).to eq(type) }
  end

  describe '#render_curl?' do
    context 'when :curl is included in the targets' do
      it { expect(subject.render_curl?).to eq(true) }
    end

    context 'when :curl is not included in the targets' do
      let(:formats) { [:yaml] }

      it { expect(subject.render_curl?).to eq(false) }
    end
  end

  describe '#render_konnect?' do
    context 'when :konnect is included in the targets' do
      it { expect(subject.render_curl?).to eq(true) }
    end

    context 'when :konnect is not included in the targets' do
      let(:formats) { [:curl] }

      it { expect(subject.render_konnect?).to eq(false) }
    end
  end

  describe '#render_yaml?' do
    context 'when :yaml is included in the targets' do
      it { expect(subject.render_yaml?).to eq(true) }
    end

    context 'when :yaml is not included in the targets' do
      let(:formats) { [:curl] }

      it { expect(subject.render_yaml?).to eq(false) }
    end
  end

  describe '#render_kubernetes?' do
    context 'when :kubernetes is included in the targets' do
      it { expect(subject.render_kubernetes?).to eq(true) }
    end

    context 'when :kubernetes is not included in the targets' do
      let(:formats) { [:curl] }

      it { expect(subject.render_kubernetes?).to eq(false) }
    end
  end

  describe '#curl' do
    it { expect(subject.curl).to be_an_instance_of(Jekyll::Drops::Plugins::Examples::Curl) }
  end

  describe '#konnect' do
    it { expect(subject.konnect).to be_an_instance_of(Jekyll::Drops::Plugins::Examples::Konnect) }
  end

  describe '#yaml' do
    it { expect(subject.yaml).to be_an_instance_of(Jekyll::Drops::Plugins::Examples::Yaml) }
  end

  describe '#kubernetes' do
    it { expect(subject.kubernetes).to be_an_instance_of(Jekyll::Drops::Plugins::Examples::Yaml) }
  end
end

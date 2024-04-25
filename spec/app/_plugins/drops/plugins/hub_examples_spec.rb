RSpec.describe Jekyll::Drops::Plugins::HubExamples do
  let(:version) { '3.2.2' }
  let(:plugin_name) { 'opentelemetry' }
  let(:schema) do
    PluginSingleSource::Plugin::Schemas::Kong.new(
      plugin_name:,
      vendor: 'kong-inc',
      version: version,
      site:
    )
  end
  let(:example) { schema.example }
  let(:targets) { [:consumer, :route, :global, :service, :consumer_group] }
  let(:formats) { [:curl, :yaml, :kubernetes] }

  subject { described_class.new(schema:, example:, formats:, targets:) }

  describe '#render?' do
    context 'when there is an example for the plugin' do
      it { expect(subject.render?).to eq(true) }
    end

    context 'when there is not an example for the plugin' do
      before do
        allow(schema).to receive(:example).and_return(nil)
      end

      it { expect(subject.render?).to eq(false) }
    end
  end

  describe '#navtabs?' do
    context 'when the plugin can be enabled on a route/service/consumer' do
      it { expect(subject.navtabs?).to eq(true) }
    end

    context 'when the plugin is global only' do
      let(:version) { '3.1.1' }

      it { expect(subject.navtabs?).to eq(false) }
    end
  end

  describe '#consumer' do
    context 'when the plugin can be enabled on a consumer' do
      it { expect(subject.consumer).to be_an_instance_of(Jekyll::Drops::Plugins::Example) }
    end

    context 'when the plugin can not be enabled on a consumer' do
      let(:version) { '3.1.1' }

      it { expect(subject.consumer).to be_nil }
    end
  end

  describe '#consumer_group' do
    let(:version) { '3.4.1' }

    context 'when the plugin can be enabled on a consumer_group' do
      let(:plugin_name) { 'request-transformer' }
      it { expect(subject.consumer_group).to be_an_instance_of(Jekyll::Drops::Plugins::Example) }
    end

    context 'when the plugin can not be enabled on a consumer_group' do
      it { expect(subject.consumer_group).to be_nil }
    end
  end

  describe '#global' do
    it { expect(subject.global).to be_an_instance_of(Jekyll::Drops::Plugins::Example) }
  end

  describe '#route' do
    context 'when the plugin can be enabled on a route' do
      it { expect(subject.route).to be_an_instance_of(Jekyll::Drops::Plugins::Example) }
    end

    context 'when the plugin can not be enabled on a route' do
      let(:version) { '3.1.1' }

      it { expect(subject.route).to be_nil }
    end
  end

  describe '#service' do
    context 'when the plugin can be enabled on a service' do
      it { expect(subject.service).to be_an_instance_of(Jekyll::Drops::Plugins::Example) }
    end

    context 'when the plugin can not be enabled on a service' do
      let(:version) { '3.1.1' }

      it { expect(subject.service).to be_nil }
    end
  end

  describe '#enable_on_consumer?' do
    context 'when the schema supports :consumer' do
      context 'when :consumer is included in targets' do
        it { expect(subject.enable_on_consumer?).to eq(true) }
      end

      context 'when :consumer is not included in targets' do
        let(:targets) { [:service, :route] }

        it { expect(subject.enable_on_consumer?).to eq(false) }
      end
    end

    context 'when the schema does not supports :consumer' do
      before do
        allow(schema).to receive(:enable_on_consumer?).and_return(false)
      end

      it { expect(subject.enable_on_consumer?).to eq(false) }
    end
  end

  describe '#enable_on_route?' do
    context 'when the schema supports :route' do
      context 'when :route is included in targets' do
        it { expect(subject.enable_on_route?).to eq(true) }
      end

      context 'when :route is not included in targets' do
        let(:targets) { [:service, :consumer] }

        it { expect(subject.enable_on_route?).to eq(false) }
      end
    end

    context 'when the schema does not supports :route' do
      before do
        allow(schema).to receive(:enable_on_route?).and_return(false)
      end

      it { expect(subject.enable_on_route?).to eq(false) }
    end
  end

  describe '#enable_on_service?' do
    context 'when the schema supports :service' do
      context 'when :service is included in targets' do
        it { expect(subject.enable_on_service?).to eq(true) }
      end

      context 'when :service is not included in targets' do
        let(:targets) { [:route, :consumer] }

        it { expect(subject.enable_on_service?).to eq(false) }
      end
    end

    context 'when the schema does not supports :service' do
      before do
        allow(schema).to receive(:enable_on_service?).and_return(false)
      end

      it { expect(subject.enable_on_service?).to eq(false) }
    end
  end

  describe '#enable_globally?' do
    context 'when :global is included in targets' do
      it { expect(subject.enable_globally?).to eq(true) }
    end

    context 'when :global is not included in targets' do
      let(:targets) { [:route, :consumer] }

      it { expect(subject.enable_globally?).to eq(false) }
    end
  end
end

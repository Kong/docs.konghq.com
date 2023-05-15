RSpec.describe Jekyll::Drops::Plugins::HubExamples do
  let(:version) { '3.2.2' }
  let(:schema) do
    PluginSingleSource::Plugin::Schemas::Kong.new(
      plugin_name: 'opentelemetry',
      vendor: 'kong-inc',
      version: version
    )
  end

  subject { described_class.new(schema: schema) }

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
end

RSpec.describe Jekyll::Drops::Plugins::Badges do
  let(:publisher) { 'kong-inc' }
  let(:free) { false }
  let(:konnect) { true }
  let(:paid) { true }
  let(:enterprise) { true }

  let(:metadata) do
    {
      'paid' => paid,
      'free' => free,
      'konnect' => konnect,
      'enterprise' => enterprise
    }
  end

  subject { described_class.new(metadata:, publisher:) }

  describe '#paid?' do
    context 'when the plugin is free' do
      let(:free) { true }

      it { expect(subject.paid?).to eq(false) }
    end

    context 'when the plugin is not paid' do
      let(:free) { false }
      let(:paid) { false }

      it { expect(subject.paid?).to eq(false) }
    end

    context 'when the publisher is not `kong-inc`' do
      let(:free) { false }
      let(:paid) { true }
      let(:publisher) { 'third-party' }

      it { expect(subject.paid?).to eq(false) }
    end

    context 'when the plugin is not free, is paid, and the publisher is `kong-inc`' do
      let(:free) { false }
      let(:paid) { true }
      let(:publisher) { 'kong-inc' }

      it { expect(subject.paid?).to eq(true) }
    end
  end

  describe '#konnect?' do
    context 'when `konnect` is set to false' do
      let(:konnect) { false }

      it { expect(subject.konnect?).to eq(false) }
    end

    context 'when `konnect` is set to true' do
      let(:konnect) { true }

      it { expect(subject.konnect?).to eq(true) }
    end

    context 'when `konnect` is nil' do
      let(:konnect) { nil }

      it { expect(subject.konnect?).to eq(false) }
    end
  end

  describe '#enterprise?' do
    context 'when `enterprise` is set to false' do
      let(:enterprise) { false }
      let(:free) { false }

      it { expect(subject.enterprise?).to eq(false) }
    end

    context 'when `enterprise` is not set' do
      let(:enterprise) { nil }
      let(:free) { false }

      it { expect(subject.enterprise?).to eq(false) }
    end

    context 'when `free` is set to true' do
      let(:enterprise) { true }
      let(:free) { true }

      it { expect(subject.enterprise?).to eq(false) }
    end

    context 'when `enterprise` is true and `free` is false' do
      let(:enterprise) { true }
      let(:free) { false }

      it { expect(subject.enterprise?).to eq(true) }
    end

    context 'when `enterprise` is true and `free` is nil' do
      let(:enterprise) { true }
      let(:free) { nil }

      it { expect(subject.enterprise?).to eq(true) }
    end
  end
end

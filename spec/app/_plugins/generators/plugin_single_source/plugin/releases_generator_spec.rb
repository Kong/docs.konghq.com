RSpec.describe PluginSingleSource::Plugin::ReleasesGenerator do
  describe '.call' do
    let(:releases) { ['2.4.x', '2.2.x', '2.3.x'] }
    let(:replacements) { { '2.3.x' => ['2.3.x-CE', '2.3.x-EE'], '2.1.x': ['2.1.x-CE'] } }

    subject { described_class.call(releases:, replacements:) }

    it 'overrides the releases with the corresponding replacements and sorts them' do
      expect(subject).to eq(['2.4.x', '2.3.x-EE', '2.3.x-CE', '2.2.x'])
    end
  end
end

RSpec.describe Jekyll::Drops::Plugins::Examples::Fields::Curl do
  subject { described_class.make_for(key:, values:) }

  describe '.make_for' do
    context 'when passing an array' do
      let(:key) { 'config.allow' }
      let(:values) { ['group1', 'group2'] }

      it 'create a field for every item in the array' do
        expect(subject).to all(be_an(described_class))
        expect(subject.map(&:values)).to match_array(values)
      end
    end

    context 'when passing a hash' do
      let(:key) { 'config.allow' }
      let(:values) { { 'groups' => ['group1', 'group2'] } }

      it 'creates a field for every item in the hash' do
        expect(subject).to all(be_an(described_class))
        expect(subject.map(&:key)).to match_array([
          "config.allow.groups",
          "config.allow.groups"
        ])
      end
    end

    context 'else' do
      let(:key) { 'name' }
      let(:values) { 'plugin_name' }

      it 'creates an instance of Fields::Curl' do
        expect(subject).to be_an_instance_of(described_class)
      end
    end
  end

  describe '#to_s' do
    let(:key) { 'name' }
    let(:values) { "value with \"double quotes\"" }

    it 'escapes double quotes' do
      expect(subject.to_s).to eq(
        <<~VALUE.strip
          name=value with \\"double quotes\\"
        VALUE
      )
    end
  end
end

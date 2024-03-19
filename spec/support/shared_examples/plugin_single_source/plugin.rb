RSpec.shared_examples 'a Plugin' do
  describe '#vendor' do
    it 'returns the author of the plugin' do
      expect(subject.vendor).to eq(author)
    end
  end

  describe '#name' do
    it 'returns the name of the plugin' do
      expect(subject.name).to eq(name)
    end
  end

  describe '#dir' do
    it 'returns the dir path to the plugin' do
      expect(subject.dir).to eq(dir)
    end
  end

  describe '#create_pages' do
    it { expect(subject).to respond_to(:create_pages) }
  end

  describe '#releases' do
    it { expect(subject).to respond_to(:releases) }
  end
end

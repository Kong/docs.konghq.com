RSpec.describe OasDefinitionPages::Generator do
  describe '#generate' do
    subject { described_class.new.generate(site) }

    it 'generates pages for each OAS definition + versions' do
      expect { subject }.to change { site.pages.size }.by(5)
    end
  end
end

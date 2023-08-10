RSpec.describe OasDefinitionPages::Generator do
  describe '#generate' do
    subject { described_class.new.generate(site) }

    it 'generates pages for each OAS definition + versions + index' do
      expect { subject }.to change { site.pages.size }.by(9)
    end
  end
end

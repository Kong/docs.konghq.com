RSpec.describe OasDefinition::PageUrlGenerator do
  describe '.run' do
    subject { described_class.run(file:, version:) }

    context 'namespaced api files' do
      let(:file) { '_api/gateway/admin-ee/_index.md' }

      context 'latest' do
        let(:version) { 'latest' }

        it { expect(subject).to eq('/gateway/api/admin-ee/latest/') }
      end

      context 'specific version' do
        let(:version) { '3.4.0' }

        it { expect(subject).to eq('/gateway/api/admin-ee/3.4.0/') }
      end
    end

    context 'api files without namespace' do
      let(:file) { '_api/dev-portal/_index.md' }

      context 'latest' do
        let(:version) { 'latest' }

        it { expect(subject).to eq('/dev-portal/api/latest/') }
      end

      context 'specific version' do
        let(:version) { 'v2' }

        it { expect(subject).to eq('/dev-portal/api/v2/') }
      end
    end
  end
end

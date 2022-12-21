RSpec.describe Jekyll::AliasGenerator do
  before do
    described_class.new.generate(site)
  end

  describe '#generate' do
    let(:page) do
      site.pages.detect { |p| p.relative_path == '_redirects' }
    end

    it 'generates a page called `_redirects`' do
      expect(page).not_to be_nil
    end

    it 'sets its layout to `nil`' do
      expect(page.data['layout']).to be_nil
    end

    context 'in its content' do
      let(:redirects) { page.content.split("\n").map { |l| l.squeeze(' ') } }

      it 'includes existing redirects' do
        expect(redirects).to include('/gateway/3.0.x/install-and-run/centos /gateway/latest/install-and-run/os-support')
        expect(redirects).to include('/deck/overview/ /deck/')
        expect(redirects).to include('/enterprise/latest/getting-started/ /gateway/latest/get-started/comprehensive')
      end

      it 'includes moved_urls separated by tabs, and replaces `VERSION` with `latest`' do
        expect(redirects).to include("/gateway-oss/latest/configuration/\t/gateway/latest/reference/configuration/")
        expect(redirects).to include("/gateway/latest/get-started/configure-services-and-routes/\t/gateway/latest/get-started/services-and-routes/")
        expect(redirects).to include("/gateway/latest/install-and-run/\t/gateway/latest/install/")
      end

      it 'includes `aliases` defined in frontmatters separated by tabs' do
        expect(redirects).to include("/first-alias/index.html\t/contributing/")
        expect(redirects).to include("/second-alias/index.html\t/contributing/")
      end
    end
  end
end

RSpec.describe Sitemap::Generator do
  before { generate_site! }

  describe '.generate' do
    subject! { described_class.new.generate(site) }

    it 'generates and sets the sitemap to the site' do
      expect(site.data['sitemap_pages']).to be_an_instance_of(Array)
    end
  end
end

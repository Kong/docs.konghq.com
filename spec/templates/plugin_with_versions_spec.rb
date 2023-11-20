RSpec.describe 'Plugin page with multiple versions' do
  let(:page) { find_page_by_url(page_url) }
  let(:html) { Capybara::Node::Simple.new(page.output) }

  before do
    generate_site!
    render_page(page: page)
  end

  context 'versions with a specific file - _2.6.x' do
    let(:page_url) { '/hub/kong-inc/jwt-signer/2.6.x/' }

    it 'renders the content' do
      expect(html).to have_css('h2', text: '_2.6.x Description')
      expect(html).to have_css('p', text: 'content: Verify and (re-)sign one or two tokens in a request')
    end

    it 'renders metadata in the header' do
      expect(html).to have_css('.page-header--info-icon')
      expect(html).to have_css('h1#main', text: 'Kong JWT Signer')
      expect(html).to have_css('.badge.paid')
      expect(html).to have_css('.badge.enterprise')
      expect(html).to have_css('.old-version-banner')
    end
  end

  context 'versions using _index' do
    let(:page_url) { '/hub/kong-inc/jwt-signer/' }

    it 'renders the content' do
      expect(html).to have_css('h2', text: 'Manage key signing')
      expect(html).to have_css('p', text: 'If you specify')
    end

    it 'renders metadata in the header' do
      expect(html).to have_css('.page-header--info-icon')
      expect(html).to have_css('h1#main', text: 'Kong JWT Signer')
      expect(html).to have_css('.badge.paid')
      expect(html).to have_css('.badge.enterprise')
      expect(html).not_to have_css('.old-version-banner')
    end

    context 'plugins that are `paid` or `premium`' do
      it 'renders a banner for using the plugins in Konnect' do
        expect(html).to have_css('blockquote', text: 'Did you know that you can try this plugin without talking to anyone with a free')
      end
    end
  end
end

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
      expect(html).to have_css('p', text: 'Verify and (re-)sign one or two tokens in a request')
    end

    it 'renders metadata in the header' do
      expect(html).to have_css('.page-header--info-icon')
      expect(html).to have_css('h1#main', text: 'Kong JWT Signer')
      expect(html).to have_css('.badge.paid')
      expect(html).to have_css('.badge.enterprise')
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
    end

    it 'renders the sidenav' do
      expect(html).to have_css('.docs-sidebar .sidebar-item:nth-of-type(2)', text: 'Introduction')
      expect(html).to have_css('.docs-sidebar .sidebar-item:nth-of-type(3)', text: 'Configuration reference')
      expect(html).to have_css('.docs-sidebar .sidebar-item:nth-of-type(4)', text: 'Using the plugin')
      expect(html).to have_css('.docs-sidebar .sidebar-item:nth-of-type(5)', text: 'Changelog')

      how_tos = html.find('.docs-sidebar .sidebar-item:nth-of-type(4)', text: 'Using the plugin')
      expect(how_tos).to have_css('.sidebar-item:nth-of-type(1)', text: 'Basic config examples')
      expect(how_tos).to have_css('.sidebar-item:nth-of-type(2)', text: 'Nested')
      expect(how_tos).to have_css('.sidebar-item:nth-of-type(3)', text: 'Manage key signing')

      nested_how_tos = how_tos.find('.sidebar-item:nth-of-type(2)', text: /^Nested$/)
      expect(nested_how_tos).to have_css('.sidebar-item', text: 'Nested Tutorial Nav title')
      expect(nested_how_tos).to have_css('.sidebar-item', text: 'Nested Tutorial Nav title with Min and Max')
    end

    it 'renders a Konnect CTA button' do
      expect(html).to have_css('.sidebar-button', text: 'Try it in Konnect')
    end
  end
end

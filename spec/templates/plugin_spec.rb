RSpec.describe 'Plugin page' do
  let(:page) { find_page_by_url('/hub/acme/unbundled-plugin/') }
  let(:html) { Capybara::Node::Simple.new(page.output) }

  before do
    generate_site!
    render_page(page: page)
  end

  it 'renders the plugin\'s description' do
    expect(html).to have_css('p', text: 'This is a sample unbundled plugin with overrides')
  end

  it 'renders extra metadata' do
    expect(html).to have_css('strong', text: 'Configuration Notes:')
    expect(html).to have_css('p', text: "Most of the parameters are optional, but you need to specify some options to actually\nmake the plugin work:")
    expect(html).to have_css('p', text: 'For example, signature verification cannot be done without the plugin knowing about')
    expect(html).to have_css('p', text: 'Also for introspection to work, you need to specify introspection endpoints')
  end

  it 'renders metadata in the header' do
    expect(html).to have_css('.hub-page-header--info-icon')
    expect(html).to have_css('h1#main', text: 'Unbundled Plugin')
    expect(html).not_to have_css('.badge.konnect')
    expect(html).not_to have_css('.badge.plus')
    expect(html).to have_css('.badge.enterprise')
    expect(html).not_to have_css('.badge.oss')
    expect(html).not_to have_css('.old-version-banner')
  end

  it 'renders the content' do
    expect(html).to have_css('h2', text: 'Manage key signing')
  end
end

RSpec.describe 'Plugin page' do
  let(:page) { find_page_by_url('/hub/acme/unbundled-plugin/') }
  let(:html) { Capybara::Node::Simple.new(page.output) }

  before do
    generate_site!
    render_page(page: page)
  end

  it 'renders metadata in the header' do
    expect(html).to have_css('.page-header--info-icon')
    expect(html).to have_css('h1#main', text: 'Unbundled Plugin')
    expect(html).not_to have_css('.badge.konnect')
    expect(html).not_to have_css('.badge.paid')
    expect(html).not_to have_css('.badge.premium')
    expect(html).to have_css('.badge.enterprise')
    expect(html).not_to have_css('.badge.oss')
  end

  it 'renders the content' do
    expect(html).to have_css('h2', text: 'Manage key signing')
  end
end

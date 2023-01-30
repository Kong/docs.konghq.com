RSpec.describe 'Plugin page with multiple versions' do
  let(:page) { find_page_by_url(page_url) }
  let(:html) { Capybara::Node::Simple.new(page.output) }

  before do
    generate_site!
    render_page(page: page)
  end

  context 'versions with a specific file - _2.2.x' do
    let(:page_url) { '/hub/acme/jwt-signer/2.5.x.html' }

    it 'renders the plugin\'s description' do
      expect(html).to have_css('p', text: 'From _2.2.x.md: The Kong JWT Signer plugin makes it possible to verify and (re-)sign one or two tokens in a request.')
    end

    it 'renders the content' do
      expect(html).to have_css('h2', text: '_2.2.x Description')
      expect(html).to have_css('p', text: 'content: Verify and (re-)sign one or two tokens in a request')
    end

    it 'renders metadata in the header' do
      expect(html).to have_css('.page-header-icon')
      expect(html).to have_css('h1#main', text: 'Kong JWT Signer')
      expect(html).to have_css('.badge.plus')
      expect(html).to have_css('.badge.enterprise')
      expect(html).to have_css('.old-version-banner')
    end

    it 'renders information about the plugin in the sidenav' do
      expect(html).to have_css('th', text: 'About this Plugin')
      expect(html).to have_css('tr.version', text: 'Plugin Version 1.7.0', normalize_ws: true)
      expect(html).to have_css('tr.publisher', text: 'Made by Kong Inc.', normalize_ws: true)
      expect(html).to have_css('tr.categories', text: 'Authentication')

      expect(html).to have_css('tr', text: 'DB-less compatible?')
      expect(html).to have_link('Yes', href: '/hub/plugins/compatibility')
      expect(html).not_to have_css('tr', text: 'Konnect Cloud compatible?')

      expect(html).not_to have_css('tr', text: 'Compatible protocols')
      expect(html).not_to have_css('td', text: 'Support')
      expect(html).not_to have_css('td', text: 'Source')
      expect(html).not_to have_css('td', text: 'Legal')

      expect(html).not_to have_css('tr.kong-editions', text: 'Version Compatibility')
    end

    it 'renders params.config.extra when present' do
      expect(html).not_to have_css('strong', text: 'Configuration Notes:')
    end

    it 'renders the configuration parameters table' do
      expect(html).to have_css('h3', text: 'Parameters')
      expect(html).to have_css('th', text: 'Form Parameter')
      expect(html).to have_css('th', text: 'Description')

      table = html.find('table:not(#about-extn)')

      name = table.find('tbody tr:nth-of-type(1)')
      expect(name).to have_css('code', text: 'name')
      expect(name).to have_css('i', text: 'required')
      expect(name).to have_css('td', text: 'The name of the plugin, in this case jwt-signer.')
      expect(name).to have_css('td', text: 'Type: string')

      service = table.find('tbody tr:nth-of-type(2)')
      expect(service).to have_css('td', text: 'service.name or service.id')
      expect(service).to have_css('td', text: 'Type: string')
      expect(service).not_to have_css('td', text: 'Default value')
      expect(service).to have_css('td', text: 'The name or ID of the service the plugin targets.')

      route = table.find('tbody tr:nth-of-type(3)')
      expect(route).to have_css('td', text: 'route.name or route.id')
      expect(route).to have_css('td', text: 'Type: string')
      expect(route).not_to have_css('td', text: 'Default value')
      expect(route).to have_css('td', text: 'The name or ID of the route the plugin targets.')

      expect(html).not_to have_css('td', text: 'consumer.name or consumer.id')

      enabled = table.find('tbody tr:nth-of-type(4)')
      expect(enabled).to have_css('td', text: 'enabled')
      expect(enabled).to have_css('td', text: 'Type: boolean')
      expect(enabled).to have_css('td', text: 'Default value: true')
      expect(enabled).to have_css('td', text: 'Whether this plugin will be applied.')

      api_id = table.find('tbody tr:nth-of-type(5)')
      expect(api_id).to have_css('td', text: 'api_id')
      expect(api_id).to have_css('td', text: 'Type: string')
      expect(api_id).to have_css('td', text: 'The ID of the API the plugin targets.')
    end

    it 'renders the changelog' do
      expect(html).to have_css('h2#_22x-changelog', text: '_2.2.x Changelog')
    end
  end

  context 'versions using _index' do
    let(:page_url) { '/hub/acme/jwt-signer/' }

    it 'renders the plugin\'s description' do
      expect(html).to have_css('p', text: "From _index.md:")
    end

    it 'renders the content' do
      expect(html).to have_css('h2', text: 'Manage key signing')
      expect(html).to have_css('p', text: 'If you specify')
    end

    it 'renders metadata in the header' do
      expect(html).to have_css('.page-header-icon')
      expect(html).to have_css('h1#main', text: 'Kong JWT Signer')
      expect(html).to have_css('.badge.plus')
      expect(html).to have_css('.badge.enterprise')
      expect(html).not_to have_css('.old-version-banner')
    end

    it 'renders information about the plugin in the sidenav' do
      expect(html).to have_css('th', text: 'About this Plugin')
      expect(html).to have_css('tr.version', text: 'Plugin Version 1.9.1', normalize_ws: true)
      expect(html).to have_css('tr.publisher', text: 'Made by Kong Inc.', normalize_ws: true)
      expect(html).to have_css('tr.categories', text: 'Authentication')

      expect(html).to have_css('tr', text: 'DB-less compatible?')
      expect(html).to have_link('Yes', href: '/hub/plugins/compatibility')
      expect(html).not_to have_css('tr', text: 'Konnect Cloud compatible?')

      expect(html).to have_css('tr', text: 'Compatible protocols')
      expect(html).to have_css('.protocol', text: 'http')
      expect(html).to have_css('.protocol', text: 'https')
      expect(html).to have_css('.protocol', text: 'grpc')
      expect(html).to have_css('.protocol', text: 'grpcs')

      expect(html).not_to have_css('td', text: 'Support')
      expect(html).not_to have_css('td', text: 'Source')
      expect(html).not_to have_css('td', text: 'Legal')

      expect(html).not_to have_css('tr.kong-editions', text: 'Version Compatibility')
    end

    it 'renders params.config.extra when present' do
      expect(html).to have_css('strong', text: 'Configuration Notes:')
      expect(html).to have_css('p', text: "Most of the parameters are optional, but you need to specify some options to actually\nmake the plugin work:")
      expect(html).to have_css('p', text: 'For example, signature verification cannot be done without the plugin knowing about')
      expect(html).to have_css('p', text: 'Also for introspection to work, you need to specify introspection endpoints')
    end

    it 'renders the configuration parameters table' do
      expect(html).to have_css('h3', text: 'Parameters')
      expect(html).to have_css('th', text: 'Form Parameter')
      expect(html).to have_css('th', text: 'Description')

      table = html.find('table:not(#about-extn)')

      name = table.find('tbody tr:nth-of-type(1)')
      expect(name).to have_css('code', text: 'name')
      expect(name).to have_css('i', text: 'required')
      expect(name).to have_css('td', text: 'The name of the plugin, in this case jwt-signer.')
      expect(name).to have_css('td', text: 'Type: string')

      service = table.find('tbody tr:nth-of-type(2)')
      expect(service).to have_css('td', text: 'service.name or service.id')
      expect(service).to have_css('td', text: 'Type: string')
      expect(service).not_to have_css('td', text: 'Default value')
      expect(service).to have_css('td', text: 'The name or ID of the service the plugin targets.')

      route = table.find('tbody tr:nth-of-type(3)')
      expect(route).to have_css('td', text: 'route.name or route.id')
      expect(route).to have_css('td', text: 'Type: string')
      expect(route).not_to have_css('td', text: 'Default value')
      expect(route).to have_css('td', text: 'The name or ID of the route the plugin targets.')

      expect(html).not_to have_css('td', text: 'consumer.name or consumer.id')

      enabled = table.find('tbody tr:nth-of-type(4)')
      expect(enabled).to have_css('td', text: 'enabled')
      expect(enabled).to have_css('td', text: 'Type: boolean')
      expect(enabled).to have_css('td', text: 'Default value: true')
      expect(enabled).to have_css('td', text: 'Whether this plugin will be applied.')

      expect(html).not_to have_css('td', text: 'api_id')

      realm = table.find('tbody tr:nth-of-type(5)')
      expect(realm).to have_css('code', text: 'config.realm')
      expect(realm).to have_css('em', text: 'optional')
      expect(realm).to have_css('td', text: 'Type: string')
      expect(realm).to have_css('td', text: 'Default value: ngx.var.host')
      expect(realm).to have_css('p', text: 'When authentication or authorization fails')
    end

    it 'renders the changelog' do
      expect(html).to have_css('h2#changelog', text: 'Changelog')
    end
  end
end

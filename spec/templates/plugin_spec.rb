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

  xit 'renders the configuration parameters table' do
    expect(html).to have_css('h3', text: 'Parameters')

    table = html.find('table:not(#about-extn)')

    name = table.find('tbody tr:nth-of-type(1)')
    expect(name).to have_css('code', text: 'name')
    expect(name).to have_css('i', text: 'required')
    expect(name).to have_css('td', text: 'The name of the plugin, in this case unbundled-plugin.')
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

    enable_hs_signatures = table.find('tbody tr:nth-of-type(6)')
    expect(enable_hs_signatures).to have_css('code', text: 'config.enable_hs_signatures')
    expect(enable_hs_signatures).to have_css('em', text: 'optional')
    expect(enable_hs_signatures).to have_css('td', text: 'Type: boolean')
    expect(enable_hs_signatures).to have_css('td', text: 'Default value: false')
    expect(enable_hs_signatures).to have_css('p', text: 'Tokens signed with HMAC algorithms such as')

    enable_instrumentation = table.find('tbody tr:nth-of-type(7)')
    expect(enable_instrumentation).to have_css('code', text: 'config.enable_instrumentation')
    expect(enable_instrumentation).to have_css('em', text: 'optional')
    expect(enable_instrumentation).to have_css('td', text: 'Type: boolean')
    expect(enable_instrumentation).to have_css('td', text: 'Default value: false')
    expect(enable_instrumentation).to have_css('p', text: 'When you are experiencing problems in production')

    access_token_issuer = table.find('tbody tr:nth-of-type(8)')
    expect(access_token_issuer).to have_css('code', text: 'config.access_token_issuer')
    expect(access_token_issuer).to have_css('em', text: 'optional')
    expect(access_token_issuer).to have_css('td', text: 'Type: string')
    expect(access_token_issuer).to have_css('td', text: 'Default value: kong')
    expect(access_token_issuer).to have_css('p', text: 'claim of a signed or re-signed access token is set to this value.')

    access_token_keyset = table.find('tbody tr:nth-of-type(9)')
    expect(access_token_keyset).to have_css('code', text: 'config.access_token_keyset')
    expect(access_token_keyset).to have_css('em', text: 'optional')
    expect(access_token_keyset).to have_css('td', text: 'Type: string')
    expect(access_token_keyset).to have_css('td', text: 'Default value: kong')
    expect(access_token_keyset).to have_css('p', text: 'Selects the private key for access token signing.')

    access_token_jwks_uri = table.find('tbody tr:nth-of-type(10)')
    expect(access_token_jwks_uri).to have_css('code', text: 'config.access_token_jwks_uri')
    expect(access_token_jwks_uri).to have_css('em', text: 'optional')
    expect(access_token_jwks_uri).to have_css('td', text: 'Type: string')
    expect(access_token_jwks_uri).not_to have_css('td', text: 'Default value')
    expect(access_token_jwks_uri).to have_content('If you want to use config.verify_access_token_signature')

    access_token_request_header = table.find('tbody tr:nth-of-type(11)')
    expect(access_token_request_header).to have_css('code', text: 'config.access_token_request_header')
    expect(access_token_request_header).to have_css('em', text: 'optional')
    expect(access_token_request_header).to have_css('td', text: 'Type: string')
    expect(access_token_request_header).to have_css('td', text: 'Default value: authorization')
    expect(access_token_request_header).to have_css('p', text: 'This parameter tells the name of the header where to look for the access token.')

    access_token_leeway = table.find('tbody tr:nth-of-type(12)')
    expect(access_token_leeway).to have_css('code', text: 'config.access_token_leeway')
    expect(access_token_leeway).to have_css('em', text: 'optional')
    expect(access_token_leeway).to have_css('td', text: 'Type: number')
    expect(access_token_leeway).to have_css('td', text: 'Default value: 0')
    expect(access_token_leeway).to have_css('p', text: 'Adjusts clock skew between the token issuer and Kong.')

    access_token_scopes_required = table.find('tbody tr:nth-of-type(13)')
    expect(access_token_scopes_required).to have_css('code', text: 'config.access_token_scopes_required')
    expect(access_token_scopes_required).to have_css('em', text: 'optional')
    expect(access_token_scopes_required).to have_css('td', text: 'Type: array of string elements')
    expect(access_token_scopes_required).not_to have_css('td', text: 'Default value')
    expect(access_token_scopes_required).to have_css('p', text: 'Specify the required values (or scopes) that are checked by a')

    access_token_scopes_claim = table.find('tbody tr:nth-of-type(14)')
    expect(access_token_scopes_claim).to have_css('code', text: 'config.access_token_scopes_claim')
    expect(access_token_scopes_claim).to have_css('em', text: 'optional')
    expect(access_token_scopes_claim).to have_css('td', text: 'Type: array of string elements')
    expect(access_token_scopes_claim).to have_css('td', text: 'Default value: [“scope”]')
    expect(access_token_scopes_claim).to have_css('p', text: 'Specify the claim in an access token to verify against values of')

    access_token_consumer_claim = table.find('tbody tr:nth-of-type(15)')
    expect(access_token_consumer_claim).to have_css('code', text: 'config.access_token_consumer_claim')
    expect(access_token_consumer_claim).to have_css('em', text: 'optional')
    expect(access_token_consumer_claim).to have_css('td', text: 'Type: array of string elements')
    expect(access_token_consumer_claim).not_to have_css('td', text: 'Default value')
    expect(access_token_consumer_claim).to have_css('p', text: 'When you set a value for this parameter, the plugin tries to map an arbitrary')

    access_token_consumer_by = table.find('tbody tr:nth-of-type(16)')
    expect(access_token_consumer_by).to have_css('code', text: 'config.access_token_consumer_by')
    expect(access_token_consumer_by).to have_css('em', text: 'optional')
    expect(access_token_consumer_by).to have_css('td', text: 'Type: array of string elements')
    expect(access_token_consumer_by).to have_css('td', text: 'Default value: [“username”, “custom_id”]')
    expect(access_token_consumer_by).to have_css('p', text: 'When the plugin tries to apply an access token to a Kong consumer mapping,')

    access_token_upstream_header = table.find('tbody tr:nth-of-type(17)')
    expect(access_token_upstream_header).to have_css('code', text: 'config.access_token_upstream_header')
    expect(access_token_upstream_header).to have_css('em', text: 'optional')
    expect(access_token_upstream_header).to have_css('td', text: 'Type: string')
    expect(access_token_upstream_header).to have_css('td', text: 'Default value: authorization:bearer')
    expect(access_token_upstream_header).to have_css('p', text: 'Removes the config.access_token_request_header from the request after reading its')

    access_token_upstream_leeway = table.find('tbody tr:nth-of-type(18)')
    expect(access_token_upstream_leeway).to have_css('code', text: 'config.access_token_upstream_leeway')
    expect(access_token_upstream_leeway).to have_css('em', text: 'optional')
    expect(access_token_upstream_leeway).to have_css('td', text: 'Type: number')
    expect(access_token_upstream_leeway).to have_css('td', text: 'Default value: 0')
    expect(access_token_upstream_leeway).to have_css('p', text: 'If you want to add or perhaps subtract (using a negative value) expiry')

    access_token_introspection_endpoint = table.find('tbody tr:nth-of-type(19)')
    expect(access_token_introspection_endpoint).to have_css('code', text: 'config.access_token_introspection_endpoint')
    expect(access_token_introspection_endpoint).to have_css('em', text: 'optional')
    expect(access_token_introspection_endpoint).to have_css('td', text: 'Type: string')
    expect(access_token_introspection_endpoint).not_to have_css('td', text: 'Default value')
    expect(access_token_introspection_endpoint).to have_css('p', text: 'When you use opaque access tokens and you want to turn on access token')

    access_token_introspection_authorization = table.find('tbody tr:nth-of-type(20)')
    expect(access_token_introspection_authorization).to have_css('code', text: 'config.access_token_introspection_authorization')
    expect(access_token_introspection_authorization).to have_css('em', text: 'optional')
    expect(access_token_introspection_authorization).to have_css('td', text: 'Type: string')
    expect(access_token_introspection_authorization).not_to have_css('td', text: 'Default value')
    expect(access_token_introspection_authorization).to have_css('p', text: 'If the introspection endpoint requires client authentication (client being')

    access_token_introspection_body_args = table.find('tbody tr:nth-of-type(21)')
    expect(access_token_introspection_body_args).to have_css('code', text: 'config.access_token_introspection_body_args')
    expect(access_token_introspection_body_args).to have_css('em', text: 'optional')
    expect(access_token_introspection_body_args).to have_css('td', text: 'Type: string')
    expect(access_token_introspection_body_args).not_to have_css('td', text: 'Default value')
    expect(access_token_introspection_body_args).to have_css('p', text: 'If you need to pass additional body arguments to an introspection endpoint')

    access_token_introspection_hint = table.find('tbody tr:nth-of-type(22)')
    expect(access_token_introspection_hint).to have_css('code', text: 'config.access_token_introspection_hint')
    expect(access_token_introspection_hint).to have_css('em', text: 'optional')
    expect(access_token_introspection_hint).to have_css('td', text: 'Type: string')
    expect(access_token_introspection_hint).to have_css('td', text: 'Default value: access_token')
    expect(access_token_introspection_hint).to have_css('p', text: 'If you need to give hint parameter when introspecting an access token')

    access_token_introspection_jwt_claim = table.find('tbody tr:nth-of-type(23)')
    expect(access_token_introspection_jwt_claim).to have_css('code', text: 'config.access_token_introspection_jwt_claim')
    expect(access_token_introspection_jwt_claim).to have_css('em', text: 'optional')
    expect(access_token_introspection_jwt_claim).to have_css('td', text: 'Type: array of string elements')
    expect(access_token_introspection_jwt_claim).not_to have_css('td', text: 'Default value')
    expect(access_token_introspection_jwt_claim).to have_css('p', text: 'If your introspection endpoint returns an access token in one of the keys')

    access_token_introspection_scopes_required = table.find('tbody tr:nth-of-type(24)')
    expect(access_token_introspection_scopes_required).to have_css('code', text: 'config.access_token_introspection_scopes_required')
    expect(access_token_introspection_scopes_required).to have_css('em', text: 'optional')
    expect(access_token_introspection_scopes_required).to have_css('td', text: 'Type: array of string elements')
    expect(access_token_introspection_scopes_required).not_to have_css('td', text: 'Default value')
    expect(access_token_introspection_scopes_required).to have_css('p', text: 'Specify the required values (or scopes) that are checked by an')

    access_token_introspection_scopes_claim = table.find('tbody tr:nth-of-type(25)')
    expect(access_token_introspection_scopes_claim).to have_css('code', text: 'config.access_token_introspection_scopes_claim')
    expect(access_token_introspection_scopes_claim).to have_css('em', text: 'required')
    expect(access_token_introspection_scopes_claim).to have_css('td', text: 'Type: array of string elements')
    expect(access_token_introspection_scopes_claim).to have_css('td', text: 'Default value: [“scope”]')
    expect(access_token_introspection_scopes_claim).to have_css('p', text: 'Specify the claim/property in access token introspection results')

    access_token_introspection_consumer_claim = table.find('tbody tr:nth-of-type(26)')
    expect(access_token_introspection_consumer_claim).to have_css('code', text: 'config.access_token_introspection_consumer_claim')
    expect(access_token_introspection_consumer_claim).to have_css('em', text: 'optional')
    expect(access_token_introspection_consumer_claim).to have_css('td', text: 'Type: array of string elements')
    expect(access_token_introspection_consumer_claim).not_to have_css('td', text: 'Default value')
    expect(access_token_introspection_consumer_claim).to have_css('p', text: 'When you set a value for this parameter, the plugin tries to map an arbitrary')
  end

  it 'renders params.config.extra' do
    expect(html).to have_css('strong', text: 'Configuration Notes:')
    expect(html).to have_css('p', text: "Most of the parameters are optional, but you need to specify some options to actually\nmake the plugin work:")
    expect(html).to have_css('p', text: 'For example, signature verification cannot be done without the plugin knowing about')
    expect(html).to have_css('p', text: 'Also for introspection to work, you need to specify introspection endpoints')
  end

  xit 'renders the changelog' do
    expect(html).to have_css('h2#changelog', text: 'Changelog')
    expect(html).to have_css('blockquote p', text: 'handler.lua version: 1.9.0')
    expect(html).to have_css('p', text: 'Starting with Kong Gateway 2.7.0.0, if keyring encryption is enabled')
  end

  it 'renders metadata in the header' do
    expect(html).to have_css('.page-header-icon')
    # expect(html).not_to have_css('.breadcrumbs')
    expect(html).to have_css('h1#main', text: 'Unbundled Plugin')
    expect(html).not_to have_css('.badge.konnect')
    expect(html).not_to have_css('.badge.plus')
    expect(html).to have_css('.badge.enterprise')
    expect(html).not_to have_css('.badge.oss')
    expect(html).not_to have_css('.old-version-banner')
  end

  xit 'renders information about the plugin in the sidenav' do
    expect(html).to have_css('th', text: 'About this Plugin')
    expect(html).to have_css('tr.version', text: 'Plugin Version 3.0.x', normalize_ws: true)
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

  it 'renders the content' do
    expect(html).to have_css('h2', text: 'Manage key signing')
  end
end

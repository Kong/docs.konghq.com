RSpec.describe 'Plugin page' do
  let(:page) { find_page_by_url('/hub/acme/unbundled-plugin/configuration/') }
  let(:html) { Capybara::Node::Simple.new(page.output) }

  before do
    generate_site!
    render_page(page: page)
  end

  it 'renders the corresponding sidenav' do
    sidebar = html.find('.docs-sidebar')

    expect(sidebar).to have_link('Overview', href: '/hub/acme/unbundled-plugin/')
    expect(sidebar).to have_link('Reference', href: '/hub/acme/unbundled-plugin/configuration/')
    expect(sidebar).to have_link('Changelog', href: '/hub/acme/unbundled-plugin/changelog/')
  end

  it 'renders the protocols' do
    expect(html).to have_css('h3', text: 'Compatible protocols')
    expect(html).to have_css('p', text: 'The Unbundled Plugin plugin is compatible with the following protocols:')
    expect(html).to have_css('p', text: 'http, https, grpc, grpcs')
  end

  it 'renders the schema' do
    expect(html).to have_css('h2', text: 'Configuration')

    fields = html.find('.fields')

    name = fields.find('> .field:nth-of-type(1)')
    expect(name).to have_css('h4', text: 'name')
    expect(name).to have_css('strong', text: 'string')
    expect(name).to have_css('.required', text: 'required')
    expect(name).to have_css('.field-description', text: 'The name of the plugin, in this case unbundled-plugin.')

    service = fields.find('> .field:nth-of-type(2)')
    expect(service).to have_css('h4', text: 'service.name or service.id')
    expect(service).to have_css('strong', text: 'string')
    expect(service).not_to have_css('.default')
    expect(service).to have_css('.field-description', text: 'The name or ID of the service the plugin targets.')

    route = fields.find('> .field:nth-of-type(3)')
    expect(route).to have_css('h4', text: 'route.name or route.id')
    expect(route).to have_css('strong', text: 'string')
    expect(route).not_to have_css('.default')
    expect(route).to have_css('.field-description', text: 'The name or ID of the route the plugin targets.')

    expect(html).not_to have_css('td', text: 'consumer.name or consumer.id')

    enabled = fields.find('> .field:nth-of-type(4)')
    expect(enabled).to have_css('h4', text: 'enabled')
    expect(enabled).to have_css('strong', text: 'boolean')
    expect(enabled).to have_text('default: true')
    expect(enabled).to have_css('.field-description', text: 'Whether this plugin will be applied.')

    expect(html).not_to have_css('td', text: 'api_id')

    config = fields.find('> .field:nth-of-type(5)')
    expect(config).to have_css('h4', text: 'config')
    expect(config).to have_css('.field-description-and-children')
    expect(config).to have_css('.required')

    config_fields = config.find('> .field-description-and-children > .field-subfield__params')

    realm = config_fields.find('> ul:nth-of-type(1)')
    expect(realm).to have_css('h4', text: 'realm')
    expect(realm).to have_css('strong', text: 'string')
    expect(realm).to have_css('.default', text: 'ngx.var.host')
    expect(realm).to have_css('.field-description', text: 'When authentication or authorization fails')

    enable_hs_signatures = config_fields.find('> ul:nth-of-type(2)')
    expect(enable_hs_signatures).to have_css('h4', text: 'enable_hs_signatures')
    expect(enable_hs_signatures).to have_css('strong', text: 'boolean')
    expect(enable_hs_signatures).to have_css('.default', text: 'false')
    expect(enable_hs_signatures).to have_css('.field-description', text: 'Tokens signed with HMAC algorithms such as')

    enable_instrumentation = config_fields.find('> ul:nth-of-type(3)')
    expect(enable_instrumentation).to have_css('h4', text: 'enable_instrumentation')
    expect(enable_instrumentation).to have_css('strong', text: 'boolean')
    expect(enable_instrumentation).to have_css('.default', text: 'false')
    expect(enable_instrumentation).to have_css('.field-description', text: 'When you are experiencing problems in production')

    access_token_issuer = config_fields.find('> ul:nth-of-type(4)')
    expect(access_token_issuer).to have_css('h4', text: 'access_token_issuer')
    expect(access_token_issuer).to have_css('strong', text: 'string')
    expect(access_token_issuer).to have_css('.default', text: 'kong')
    expect(access_token_issuer).to have_css('.field-description', text: 'claim of a signed or re-signed access token is set to this value.')

    access_token_keyset = config_fields.find('> ul:nth-of-type(5)')
    expect(access_token_keyset).to have_css('h4', text: 'access_token_keyset')
    expect(access_token_keyset).to have_css('strong', text: 'string')
    expect(access_token_keyset).to have_css('.default', text: 'kong')
    expect(access_token_keyset).to have_css('.field-description', text: 'Selects the private key for access token signing.')

    access_token_jwks_uri = config_fields.find('> ul:nth-of-type(6)')
    expect(access_token_jwks_uri).to have_css('h4', text: 'access_token_jwks_uri')
    expect(access_token_jwks_uri).to have_css('strong', text: 'string')
    expect(access_token_jwks_uri).not_to have_css('.default')
    expect(access_token_jwks_uri).to have_css('.field-description', text: 'If you want to use config.verify_access_token_signature')

    access_token_request_header = config_fields.find('> ul:nth-of-type(7)')
    expect(access_token_request_header).to have_css('h4', text: 'access_token_request_header')
    expect(access_token_request_header).to have_css('strong', text: 'string')
    expect(access_token_request_header).to have_css('.default', text: 'authorization')
    expect(access_token_request_header).to have_css('.field-description', text: 'This parameter tells the name of the header where to look for the access token.')

    access_token_leeway = config_fields.find('> ul:nth-of-type(8)')
    expect(access_token_leeway).to have_css('h4', text: 'access_token_leeway')
    expect(access_token_leeway).to have_css('strong', text: 'number')
    expect(access_token_leeway).to have_css('.default', text: '0')
    expect(access_token_leeway).to have_css('.field-description', text: 'Adjusts clock skew between the token issuer and Kong.')

    access_token_scopes_required = config_fields.find('> ul:nth-of-type(9)')
    expect(access_token_scopes_required).to have_css('h4', text: 'access_token_scopes_required')
    expect(access_token_scopes_required).to have_css('span', text: 'array of type string', normalize_ws: true)
    expect(access_token_scopes_required).not_to have_css('.default')
    expect(access_token_scopes_required).to have_css('.field-description', text: 'Specify the required values (or scopes) that are checked by a')

    access_token_scopes_claim = config_fields.find('> ul:nth-of-type(10)')
    expect(access_token_scopes_claim).to have_css('h4', text: 'access_token_scopes_claim')
    expect(access_token_scopes_claim).to have_css('span', text: 'array of type string', normalize_ws: true)
    expect(access_token_scopes_claim).to have_css('.default', text: 'scope')
    expect(access_token_scopes_claim).to have_css('.field-description', text: 'Specify the claim in an access token to verify against values of')

    access_token_consumer_claim = config_fields.find('> ul:nth-of-type(11)')
    expect(access_token_consumer_claim).to have_css('h4', text: 'access_token_consumer_claim')
    expect(access_token_consumer_claim).to have_css('span', text: 'array of type string', normalize_ws: true)
    expect(access_token_consumer_claim).not_to have_css('.default')
    expect(access_token_consumer_claim).to have_css('.field-description', text: 'When you set a value for this parameter, the plugin tries to map an arbitrary')

    access_token_consumer_by = config_fields.find('> ul:nth-of-type(12)')
    expect(access_token_consumer_by).to have_css('h4', text: 'access_token_consumer_by')
    expect(access_token_consumer_by).to have_css('span', text: 'array of type string', normalize_ws: true)
    expect(access_token_consumer_by).to have_css('.default', text: 'username, custom_id')
    expect(access_token_consumer_by).to have_css('.field-description', text: 'When the plugin tries to apply an access token to a Kong consumer mapping,')

    access_token_upstream_header = config_fields.find('> ul:nth-of-type(13)')
    expect(access_token_upstream_header).to have_css('h4', text: 'access_token_upstream_header')
    expect(access_token_upstream_header).to have_css('strong', text: 'string')
    expect(access_token_upstream_header).to have_css('.default', text: 'authorization:bearer')
    expect(access_token_upstream_header).to have_css('.field-description', text: 'Removes the config.access_token_request_header from the request after reading its')

    access_token_upstream_leeway = config_fields.find('> ul:nth-of-type(14)')
    expect(access_token_upstream_leeway).to have_css('h4', text: 'access_token_upstream_leeway')
    expect(access_token_upstream_leeway).to have_css('strong', text: 'number')
    expect(access_token_upstream_leeway).to have_css('.default', text: '0')
    expect(access_token_upstream_leeway).to have_css('.field-description', text: 'If you want to add or perhaps subtract (using a negative value) expiry')

    access_token_introspection_endpoint = config_fields.find('> ul:nth-of-type(15)')
    expect(access_token_introspection_endpoint).to have_css('h4', text: 'access_token_introspection_endpoint')
    expect(access_token_introspection_endpoint).to have_css('strong', text: 'string')
    expect(access_token_introspection_endpoint).not_to have_css('.default')
    expect(access_token_introspection_endpoint).to have_css('.field-description', text: 'When you use opaque access tokens and you want to turn on access token')

    access_token_introspection_authorization = config_fields.find('> ul:nth-of-type(16)')
    expect(access_token_introspection_authorization).to have_css('h4', text: 'access_token_introspection_authorization')
    expect(access_token_introspection_authorization).to have_css('strong', text: 'string')
    expect(access_token_introspection_authorization).not_to have_css('.default')
    expect(access_token_introspection_authorization).to have_css('.field-description', text: 'If the introspection endpoint requires client authentication (client being')

    access_token_introspection_body_args = config_fields.find('> ul:nth-of-type(17)')
    expect(access_token_introspection_body_args).to have_css('h4', text: 'access_token_introspection_body_args')
    expect(access_token_introspection_body_args).to have_css('strong', text: 'string')
    expect(access_token_introspection_body_args).not_to have_css('.default')
    expect(access_token_introspection_body_args).to have_css('.field-description', text: 'If you need to pass additional body arguments to an introspection endpoint')
  end
end

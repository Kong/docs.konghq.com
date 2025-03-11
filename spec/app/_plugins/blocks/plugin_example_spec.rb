RSpec.describe Jekyll::PluginExample do
  before { generate_site! }

  let(:page) { find_page_by_url('/gateway/latest/') }
  let(:environment) { { 'page' => page } }
  let(:liquid_context) { Liquid::Context.new(environment, {}, site: site, page: page.data) }
  let(:liquid_block) do
    <<~BLOCK
{% plugin_example %}
title: Opinionated Example
plugin: kong-inc/jwt-signer
name: jwt-signer
config:
  access_token_introspection_scopes_claim:
    - scope
    - realm_access
targets:
  - service
  - route
formats:
  - curl
  - kubernetes
{% endplugin_example %}
    BLOCK
  end

  let(:block) do
    Liquid::Template.parse(liquid_block)
  end

  describe '#render' do
    subject { Capybara::Node::Simple.new(block.render(liquid_context)) }

    it 'renders the plugin example for the provided targets in the specified formats' do
      expect(subject).to have_css('h3', text: 'Opinionated Example')
      expect(subject).to have_css('.navtab-title', text: 'Enable on a service')
      expect(subject).to have_css('.navtab-title', text: 'Enable on a route')

      expect(subject).not_to have_css('.navtab-title', text: /^Enable on a consumer$/)
      expect(subject).not_to have_css('.navtab-title', text: 'Enable globally')

      expect(subject).to have_css('#navtab-id-0 .navtab-title', text: 'Admin API')
      expect(subject).to have_css('#navtab-id-0 .navtab-title', text: 'Kubernetes')
      expect(subject).not_to have_css('#navtab-id-0 .navtab-title', text: 'Declarative (YAML)')

      expect(subject).to have_css('#navtab-id-1 .navtab-title', text: 'Admin API')
      expect(subject).to have_css('#navtab-id-1 .navtab-title', text: 'Kubernetes')
      expect(subject).not_to have_css('#navtab-id-1 .navtab-title', text: 'Declarative (YAML)')
    end
  end
end

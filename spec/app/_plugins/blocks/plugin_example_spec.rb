RSpec.describe Jekyll::PluginExample do
  before { generate_site! }

  let(:page) { find_page_by_url('/gateway/latest/') }
  let(:environment) { { 'page' => page } }
  let(:liquid_context) { Liquid::Context.new(environment, {}, site: site) }
  let(:liquid_block) do
    <<~BLOCK
{% plugin_example %}
name: jwt-signer-example
plugin: kong-inc/jwt-signer
example: complex-example
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
      expect(subject).to have_css('.navtab-title', text: 'Enable on a service')
      expect(subject).to have_css('.navtab-title', text: 'Enable on a route')

      expect(subject).not_to have_css('.navtab-title', text: 'Enable on a consumer')
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

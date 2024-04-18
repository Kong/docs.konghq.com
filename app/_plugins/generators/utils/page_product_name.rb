# frozen_string_literal: true

module Utils
  class PageProductName
    MAPPINGS = {
      'konnect' => 'konnect_saas',
      'mesh' => 'mesh_product_name',
      'deck' => 'deck_product_name',
      'kubernetes-ingress-controller' => 'kic_product_name',
      'gateway' => 'base_gateway',
      'gateway-operator' => 'kgo_product_name',
      'contributing' => 'contributing_product_name'
    }.freeze

    def initialize(page)
      @page = page
    end

    def product_name
      return 'Plugin' if hub_page?
      return 'OpenAPI Specifications' if oas_page?

      @page.site.config[MAPPINGS[@page.data['edition']]]
    end

    private

    def hub_page?
      @page.url.start_with?('/hub/')
    end

    def oas_page?
      @page.url == '/api/' || @page.data['layout'] == 'oas/spec'
    end
  end
end

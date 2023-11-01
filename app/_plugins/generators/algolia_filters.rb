# frozen_string_literal: true

module Jekyll
  class AlgoliaFilters < Jekyll::Generator
    priority :low

    FILTERS = {
      'contributing' => ['Contribution guidelines'],
      'deck' => ['deck'],
      'gateway' => ['Kong Gateway', 'Plugin Hub', 'deck'],
      'gateway-operator' => ['Kong Gateway Operator'],
      'konnect' => ['Kong Konnect', 'Plugin Hub', 'deck'],
      'kubernetes-ingress-controller' => ['Kong Ingress Controller', 'Kong Konnect'],
      'mesh' => ['Kong Mesh'],
      'hub' => ['Plugin Hub'],
      'homepage' => ['Kong Gateway', 'Kong Konnect', 'Kong Mesh']
    }.freeze

    def generate(site)
      site.pages.each do |page|
        filters = if page.data['edition']
                    FILTERS[page.data['edition']]
                  elsif page.url == '/'
                    FILTERS['homepage']
                  elsif page.url.start_with?('/hub')
                    FILTERS['hub']
                  end

        page.data['algolia_filters'] = algolia_filters(filters) if filters
      end
    end

    def algolia_filters(filters)
      filters
        .reverse
        .map
        .with_index(1) { |v, i| "'product:#{v}<score=#{i}>'" }.join(', ')
    end
  end
end

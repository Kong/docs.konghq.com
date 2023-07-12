# frozen_string_literal: true

# TODO:
# automate appd/_data/api_specs.json generator
# should fetch api-catalog and for each product fetch its versions

module OasSpecPages
  class Page < ::Jekyll::Page
    def initialize(site:, data:)
      @site = site

      @dir = data['dir']

      @basename = 'index'
      @ext = '.html'

      @data = data
      @content = ''
      @relative_path = data['source_file']
    end
  end

  class Generator < Jekyll::Generator
    SOURCE_FILE = 'app/_data/api_specs.json'

    def generate(site)
      products.map do |product|
        product['versions'].map do |version|
          site.pages << Page.new(
            site:,
            data: OasSpecs::PageData.generate(product:, version:)
          )
        end
      end
    end

    private

    def products
      @products ||= JSON.parse(File.read(SOURCE_FILE))
    end
  end
end

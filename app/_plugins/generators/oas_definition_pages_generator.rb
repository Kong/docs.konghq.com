# frozen_string_literal: true

module OasDefinitionPages
  class Generator < Jekyll::Generator
    SOURCE_FILE = '_data/konnect_oas_data.json'

    def generate(site)
      @site = site

      Dir.glob(File.join(site.source, '_api/*/_index.md')).each do |file|
        product = page_product(file)

        ::OasDefinition::Product.new(product:, file:, site:).generate_pages!
      end
    end

    private

    def page_product(page)
      frontmatter = Utils::FrontmatterParser.new(File.read(page)).frontmatter
      product_id = frontmatter.fetch('konnect_product_id')

      products.detect { |p| p['id'] == product_id }
    end

    def products
      @products ||= JSON.parse(File.read(File.join(@site.source, SOURCE_FILE)))
    end
  end
end

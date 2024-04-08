# frozen_string_literal: true

module OasDefinitionPages
  class Generator < Jekyll::Generator
    SOURCE_FILE = '_data/konnect_oas_data.json'

    priority :low

    def generate(site)
      @site = site
      @site.data['ssg_oas_pages'] = []

      Dir.glob(File.join(site.source, '_api/**/**/_index.md')).each do |file|
        product = page_product(file)

        ::OasDefinition::Product.new(product:, file:, site:).generate_pages!
      end

      generate_index_page!
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

    def generate_index_page!
      @site.pages << ::OasDefinition::Page.new(site: @site, data: index_page_data)
    end

    def index_page_data
      {
        'dir' => '/api/', 'permalink' => '/api/', 'canonical_url' => '/api/', 'layout' => 'oas/index',
        'source_file' => 'oas/index', 'title' => 'OpenAPI Specifications'
      }.merge!(Jekyll::Pages::TranslationMissingData.new(@site).data)
    end
  end
end

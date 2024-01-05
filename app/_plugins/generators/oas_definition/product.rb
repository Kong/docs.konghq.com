# frozen_string_literal: true

module OasDefinition
  class Product
    attr_reader :site, :file, :product

    def initialize(product:, file:, site:)
      @product = product
      @file = file.gsub("#{site.source}/", '')
      @site = site
    end

    def generate_pages!
      product['versions'].map do |version|
        data = OasDefinition::PageData.generate(product:, version:, file:, site:)

        generate_product_pages!(product, data)
      end

      generate_latest_page!
      generate_latest_error_page!
    end

    private

    def generate_product_pages!(product, data)
      site.pages << ::OasDefinition::Page.new(site:, data:)
      site.pages << ::OasDefinition::ErrorPage.new(site:, data:) if product['generateErrorsPage']
    end

    def generate_latest_page!
      version = product['latestVersion']
      data = OasDefinition::PageData.generate(product:, version:, file:, site:, latest: true)

      latest_page = ::OasDefinition::Page.new(site:, data:)

      site.data['ssg_oas_pages'] << latest_page

      site.pages << latest_page
    end

    def generate_latest_error_page!
      return unless product['generateErrorsPage']

      version = product['latestVersion']
      data = OasDefinition::PageData.generate(product:, version:, file:, site:, latest: true)

      latest_error_page = ::OasDefinition::ErrorPage.new(site:, data:)

      site.pages << latest_error_page
    end
  end
end

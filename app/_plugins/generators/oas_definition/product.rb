# frozen_string_literal: true

module OasDefinition
  class Product
    attr_reader :site, :file, :product

    def initialize(product:, file:, site:, frontmatter:)
      @product = product
      @file = file.gsub("#{site.source}/", '')
      @site = site
      @frontmatter = frontmatter
    end

    def generate_pages!
      oas_errors = oas_x_errors(@frontmatter)

      product['versions'].map do |version|
        data = OasDefinition::PageData.generate(product:, version:, file:, site:)

        generate_product_pages!(data, oas_errors)
      end

      generate_latest_page!
      generate_latest_error_page!(oas_errors)
    end

    private

    def oas_x_errors(frontmatter)
      spec_path = api_spec_path(frontmatter)
      return nil unless spec_path

      oas = load_api_file(spec_path)
      raise "Could not load #{spec_path}" unless oas

      oas['x-errors']
    end

    def api_spec_path(frontmatter)
      return nil unless frontmatter.fetch('insomnia_link', nil)

      spec_file = CGI.unescape(frontmatter.fetch('insomnia_link')).split('&uri=')[1].gsub(
        'https://raw.githubusercontent.com/Kong/docs.konghq.com/main/', ''
      )
      File.join(@site.source, '..', spec_file)
    end

    def load_api_file(api_path)
      YAML.load_file(api_path)
    end

    def generate_product_pages!(data, errors)
      site.pages << ::OasDefinition::Page.new(site:, data:)
      site.pages << ::OasDefinition::ErrorPage.new(site:, data:, errors:) if errors
    end

    def generate_latest_page!
      version = product['latestVersion']
      data = OasDefinition::PageData.generate(product:, version:, file:, site:, latest: true)

      latest_page = ::OasDefinition::Page.new(site:, data:)

      site.data['ssg_oas_pages'] << latest_page

      site.pages << latest_page
    end

    def generate_latest_error_page!(errors)
      return unless errors

      version = product['latestVersion']
      data = OasDefinition::PageData.generate(product:, version:, file:, site:, latest: true)

      latest_error_page = ::OasDefinition::ErrorPage.new(site:, data:, errors:)

      site.pages << latest_error_page
    end
  end
end

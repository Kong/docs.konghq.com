# frozen_string_literal: true

module OasDefinition
  class PageData
    def self.generate(product:, version:, file:, site:, latest: false)
      new(product:, version:, file:, site:, latest:).build_data
    end

    def initialize(product:, version:, file:, site:, latest: false)
      @product = product
      @version = version
      @file = file
      @site = site
      @latest = latest

      @data = {}
    end

    def build_data # rubocop:disable Metrics/MethodLength
      @data
        .merge!({
                  'source_file' => @file,
                  'dir' => permalink(version_segment),
                  'product' => ::Jekyll::Drops::Oas::Product.new(product: @product),
                  'permalink' => permalink(version_segment),
                  'description' => @product['description'],
                  'title' => page_title,
                  'version' => @version.slice('id', 'name'),
                  'layout' => 'oas/spec',
                  'canonical_url' => canonical_url,
                  'seo_noindex' => @latest ? nil : true,
                  'is_latest' => @latest,
                  'algolia_docsearch_meta' => algolia_docsearch_meta
                })
        .merge!(frontmatter_attrs)
    end

    private

    def permalink(version)
      PageUrlGenerator.run(file: @file, version:)
    end

    def canonical_url
      permalink('latest')
    end

    def version_segment
      return 'latest' if @latest

      if Gem::Version.correct? @version['name']
        version = @version['name'].split('.')
        version.pop
        version.join('.').concat('.x')
      else
        @version['name']
      end
    end

    def page_title
      if @latest
        "#{@product['title']} - latest"
      else
        "#{@product['title']} - #{@version['name']}"
      end
    end

    def algolia_docsearch_meta
      [
        { 'name' => 'docsearch:title', 'value' => page_title },
        { 'name' => 'docsearch:description', 'value' => @product['description'] }
      ]
    end

    def frontmatter_attrs
      Utils::FrontmatterParser.new(
        File.read(File.expand_path(@file, @site.source))
      ).frontmatter
    end
  end
end

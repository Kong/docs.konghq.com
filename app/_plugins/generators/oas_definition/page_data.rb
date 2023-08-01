# frozen_string_literal: true

module OasDefinition
  class PageData
    def self.generate(product:, version:, file:, latest: false)
      new(product:, version:, file:, latest:).build_data
    end

    def initialize(product:, version:, file:, latest: false)
      @product = product
      @version = version
      @file = file
      @latest = latest

      @data = {}
    end

    def build_data # rubocop:disable Metrics/MethodLength
      @data.merge!({
                     'source_file' => @file,
                     'dir' => permalink(version_segment),
                     'product_info' => { 'id' => @product.fetch('id') },
                     'permalink' => permalink(version_segment),
                     'description' => @product['description'],
                     'title' => page_title,
                     'version' => @version.slice('id', 'name'),
                     'layout' => 'oas-spec',
                     'canonical_url' => canonical_url
                   })
    end

    private

    def permalink(version)
      [
        '/api',
        @file.split('/')[1],
        version
      ].join('/').concat('/')
    end

    def canonical_url
      permalink('latest')
    end

    def version_segment
      return @version['name'] unless @latest

      'latest'
    end

    def page_title
      if @latest
        "#{@product['title']} - latest"
      else
        "#{@product['title']} - #{@version['name']}"
      end
    end
  end
end

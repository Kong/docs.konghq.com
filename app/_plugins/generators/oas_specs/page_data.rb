# frozen_string_literal: true

module OasSpecs
  class PageData
    def self.generate(product:, version:)
      new(product:, version:).build_data
    end

    def initialize(product:, version:)
      @product = product
      @version = version
      @data = {}
    end

    def build_data
      @data.merge!({
        'source_file' => ::OasSpecPages::Generator::SOURCE_FILE,
        'dir' => output_dir,
        'layout' => 'oas-spec',
        'product_info' => @product, # replace this with drop
        'permalink' => output_dir,
        'description' => @product['description'],
        'title' => "#{@product['title']} - #{@version['name']}",
        'version' => @version
      })
    end

    def output_dir
      [
        '/api',
        @product['title'].gsub(' ', '-'),
        @version['name']
      ].join('/').concat('/')
    end
  end
end

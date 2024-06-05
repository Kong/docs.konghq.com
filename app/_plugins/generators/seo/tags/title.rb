# frozen_string_literal: true

module SEO
  module Tags
    class Title
      def initialize(page)
        @page = page
      end

      def process
        @page.data['title_tag'] = title
      end

      def title
        return @page.site.config['title'] if @page.url == '/'

        [
          @page.data['title'],
          product,
          version
        ]
          .compact.join(' - ')
          .concat(" | #{@page.site.config['title']}")
      end

      private

      def product
        return unless product_name
        return if @page.data['title']&.include?(product_name)

        product_name
      end

      def product_name
        @product_name ||= ::Utils::PageProductName.new(@page).product_name
      end

      def version
        Version::Base.make_for(@page).version
      end
    end
  end
end

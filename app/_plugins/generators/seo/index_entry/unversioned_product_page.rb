# frozen_string_literal: true

module SEO
  module IndexEntry
    class UnversionedProductPage < Base
      def key
        @key ||= @page.url
      end

      def attributes
        super.merge('url' => @page.url, 'page' => @page)
      end
    end
  end
end

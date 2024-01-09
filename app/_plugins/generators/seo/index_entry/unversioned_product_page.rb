# frozen_string_literal: true

module SEO
  module IndexEntry
    class UnversionedProductPage < Base
      def key
        @key ||= @page.url
      end

      def process!(index)
        super(index)
        @page.data['canonical_url'] = @page.url
      end

      def indexable?(_pages_index)
        super && url_segments[1] != 'pre-1.7'
      end

      def attributes
        super.merge('url' => @page.url, 'page' => @page)
      end
    end
  end
end

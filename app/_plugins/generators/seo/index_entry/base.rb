# frozen_string_literal: true

module SEO
  module IndexEntry
    class Base
      BLOCKED_PRODUCTS = [
        '/enterprise/', '/gateway-oss/', '/getting-started-guide/'
      ].freeze

      def initialize(page)
        @page = page
      end

      def process!(_index)
        handle_blocked_products
      end

      def indexable?(_pages_index)
        true
      end

      def attributes
        {}
      end

      def key
        raise NotImplementedError, 'implement this in subclass'
      end

      private

      def handle_blocked_products
        @page.data['seo_noindex'] = true if BLOCKED_PRODUCTS.any? { |u| @page.url.include?(u) }
      end

      def url_segments
        @url_segments ||= begin
          segments = @page.url.split('/')
          segments.shift
          segments
        end
      end
    end
  end
end

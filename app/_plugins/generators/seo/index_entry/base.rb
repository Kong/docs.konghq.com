# frozen_string_literal: true

module SEO
  module IndexEntry
    class Base
      def initialize(page)
        @page = page
      end

      def process!(_index); end

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

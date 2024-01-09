# frozen_string_literal: true

module SEO
  module IndexEntry
    class NonProductPage < Base
      def key
        @key ||= @page.url
      end

      def process!(index)
        super(index)

        @page.data['canonical_url'] = @page.url
      end

      def attributes
        super.merge('url' => @page.url, 'page' => @page)
      end
    end
  end
end

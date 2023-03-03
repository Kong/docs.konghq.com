# frozen_string_literal: true

module SEO
  module IndexEntry
    class VersionedProductPage < Base
      def version
        raise NotImplementedError, 'implement this in subclass'
      end

      def indexable?(pages_index)
        !pages_index[url] || (version > pages_index[url]['version'])
      end

      def attributes
        { 'version' => version, 'url' => @page.url, 'page' => @page }
      end

      def key
        @key ||= url
      end
    end
  end
end

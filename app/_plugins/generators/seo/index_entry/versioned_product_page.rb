# frozen_string_literal: true

module SEO
  module IndexEntry
    class VersionedProductPage < Base
      def version
        raise NotImplementedError, 'implement this in subclass'
      end

      def indexable?(pages_index) # rubocop:disable Metrics/AbcSize
        # Prevent labeled releases from being added to the sitemap
        return false if @page.data['release']&.label

        !pages_index[url] ||
          (version > pages_index[url]['version'] ||
            (version == pages_index[url]['version'] && @page.data['is_latest']))
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

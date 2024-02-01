# frozen_string_literal: true

require_relative 'versioned_product_page'

module SEO
  module IndexEntry
    class GlobalPage < VersionedProductPage
      def process!(_index)
        super

        @page.data['is_latest'] = true
        @page.data['canonical_url'] = Utils::CanonicalUrl.generate(@page.url)
      end

      def version
        # If it's a global page, there's only one version of it
        # by definition so it always needs adding to the list of pages.
        # We set the version to "latest" for this URL to ensure that it's
        # always added to the index
        @version ||= Utils::Version.to_version(
          @page.site.data.dig('editions', @page.data['edition'])
          .latest_release
          .value
        )
      end

      def url
        @url ||= @page.url
      end
    end
  end
end

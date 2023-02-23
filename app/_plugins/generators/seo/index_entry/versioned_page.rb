# frozen_string_literal: true

require_relative 'versioned_product_page'

module SEO
  module IndexEntry
    class VersionedPage < VersionedProductPage
      LEGACY_GATEWAY_ENDPOINTS = ['/gateway-oss/', '/enterprise/'].freeze

      def version
        # (\d+ match or /latest/)
        @version ||= Utils::Version.to_version(url_segments[1])
      end

      def url
        # URLs under the /gateway-oss/ and /enterprise/ paths can
        # never be canonical as they're set to noindex
        #
        # Instead, check if a matching URL exists under /gateway/
        # which CAN be canonical
        @url ||= @page
                 .url
                 .gsub(url_segments[1], 'VERSION')
                 .gsub('/gateway-oss/', '/gateway/')
                 .gsub('/enterprise/', '/gateway/')
      end

      def process!(index)
        super(index)

        set_canonical_url(index)
        set_seo_noindex
      end

      private

      def set_seo_noindex
        @page.data['seo_noindex'] = true if @page.data['canonical_url'] && url_segments[1] != 'latest'
      end

      def set_canonical_url(index) # rubocop:disable Naming/AccessorMethodName
        # There will usually only be one URL to check, but gateway-oss
        # and enterprise URLs will contain two here, so we have to loop
        latest_version = Utils::Version.to_version('0.0.x')
        canonical_url = nil

        urls_to_check.each do |u|
          # Otherwise look up the URL and link to the latest version
          matching_url = index[u]
          next unless matching_url && matching_url['version'] > latest_version

          latest_version = matching_url['version']
          canonical_url = matching_url['url']
        end
        @page.data['canonical_url'] = canonical_url if canonical_url
      end

      def urls_to_check
        @urls_to_check ||= [
          url_without_version,
          moved_url,
          legacy_urls
        ].flatten.compact
      end

      def moved_url
        url = url_without_version
        resolved_url = nil
        loop do
          raise "Circular reference for #{url}" if url == moved_pages[url]

          url = moved_pages[url]
          break unless url

          resolved_url = url
        end
        resolved_url
      end

      def moved_pages
        # If a page has been renamed between versions, then we need to check
        # for the new URL in later versions too
        @moved_pages ||= ::Utils::MovedPages.pages(@page.site)
      end

      def legacy_urls
        # Legacy endpoints might match newer /gateway/ URLs so
        # we also need to check for the path under the /gateway/ docs too
        @legacy_urls ||= LEGACY_GATEWAY_ENDPOINTS.map do |old|
          url_without_version.gsub(old, '/gateway/') if url_without_version.include?(old)
        end.compact
      end

      def url_without_version
        @url_without_version ||= @page.url.gsub(url_segments[1], 'VERSION')
      end
    end
  end
end

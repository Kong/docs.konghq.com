# frozen_string_literal: true

require_relative 'hub_page'

module SEO
  module IndexEntry
    class HubHtmlPage < HubPage
      def indexable?(_pages_index)
        true
      end

      def attributes
        super.merge('version' => version)
      end

      def process!(index)
        super(index)

        @page.data['canonical_url'] ||= Utils::CanonicalUrl.generate(url)
      end

      private

      def url
        @url ||= @page.url
      end

      def version
        Utils::Version.to_version(
          Jekyll::GeneratorSingleSource::Product::Edition
          .new(edition: 'gateway', site: @page.site)
          .latest_release
          .value
        )
      end
    end
  end
end

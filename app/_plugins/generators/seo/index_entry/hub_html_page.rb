# frozen_string_literal: true

require_relative 'hub_page'

module SEO
  module IndexEntry
    class HubHtmlPage < HubPage
      def indexable?(_pages_index)
        true
      end

      def attributes
        super.merge('version' => Utils::Version.to_version('latest'))
      end

      def process!(index)
        super(index)

        @page.data['canonical_url'] ||= url
      end

      private

      def url
        @url ||= @page.url
      end
    end
  end
end

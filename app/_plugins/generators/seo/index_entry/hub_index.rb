# frozen_string_literal: true

require_relative 'hub_page'

module SEO
  module IndexEntry
    class HubIndex < HubPage
      def process!(index)
        super(index)

        @page.data['canonical_url'] = '/hub/'
      end

      def indexable?(_pages_index)
        true
      end

      private

      def url
        @url ||= @page.url
      end
    end
  end
end

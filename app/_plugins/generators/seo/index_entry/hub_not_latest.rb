# frozen_string_literal: true

require_relative 'hub_page'

module SEO
  module IndexEntry
    class HubNotLatest < HubPage
      def indexable?(_pages_index)
        false
      end

      private

      def url
        @url ||= @page.data['canonical_url']
      end
    end
  end
end

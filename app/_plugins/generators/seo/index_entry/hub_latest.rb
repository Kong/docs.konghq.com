# frozen_string_literal: true

require_relative 'hub_page'

module SEO
  module IndexEntry
    class HubLatest < HubPage
      def indexable?(_pages_index)
        true
      end

      private

      def url
        @url ||= "/#{@page.data['permalink']}"
      end
    end
  end
end

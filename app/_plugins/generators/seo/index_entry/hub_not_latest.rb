# frozen_string_literal: true

require_relative 'hub_page'

module SEO
  module IndexEntry
    class HubNotLatest < HubPage
      def indexable?(_pages_index)
        false
      end

      def process!(index)
        super(index)

        set_seo_noindex
      end

      private

      def url
        @url ||= begin
          # Remove the version at the end
          segments = @page.url.split('/')
          segments.pop
          segments.join('/').concat('/')
        end
      end

      def set_seo_noindex
        @page.data['seo_noindex'] = true
      end
    end
  end
end

# frozen_string_literal: true

module SEO
  module IndexEntry
    class HubPage < Base
      def self.for(page)
        if page.url == '/hub/'
          HubIndex.new(page)
        elsif page.data['is_latest']
          HubLatest.new(page)
        else
          HubNotLatest.new(page)
        end
      end

      def key
        @key ||= url
      end

      def attributes
        super.merge('url' => url, 'page' => @page)
      end
    end
  end
end

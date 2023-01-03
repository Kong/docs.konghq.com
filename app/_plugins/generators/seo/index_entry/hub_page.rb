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

      def process!(index)
        super(index)

        set_canonical_url
      end

      def key
        @key ||= url
      end

      def attributes
        super.merge('url' => url, 'page' => @page)
      end

      private

      def set_canonical_url
        @page.data['canonical_url'] = url
      end
    end
  end
end

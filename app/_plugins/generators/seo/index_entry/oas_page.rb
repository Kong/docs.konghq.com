# frozen_string_literal: true

module SEO
  module IndexEntry
    class OasPage < Base
      def indexable?(_pages_index)
        index? || @page.data['is_latest']
      end

      def key
        @key ||= @page.data['permalink']
      end

      def attributes
        { 'url' => @page.url, 'page' => @page }
      end

      def index?
        @page.url == '/api/'
      end
    end
  end
end

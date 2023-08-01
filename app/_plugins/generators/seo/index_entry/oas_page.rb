# frozen_string_literal: true

module SEO
  module IndexEntry
    class OasPage < Base
      def indexable?(_pages_index)
        @page.data['is_latest']
      end

      def key
        @key ||= @page.data['permalink']
      end

      def attributes
        { 'version' => version, 'url' => @page.url, 'page' => @page }
      end

      def version
        # (\d+ match or /latest/)
        @version ||= Utils::Version.to_version(
          @page.url.split('/').last
        )
      end
    end
  end
end

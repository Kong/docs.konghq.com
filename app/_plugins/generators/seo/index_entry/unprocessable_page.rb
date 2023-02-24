# frozen_string_literal: true

module SEO
  module IndexEntry
    class UnprocessablePage < Base
      def indexable?(_pages_index)
        false
      end

      def key
        @key ||= @page.url
      end
    end
  end
end

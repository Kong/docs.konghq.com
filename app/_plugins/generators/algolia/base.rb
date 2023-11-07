# frozen_string_literal: true

module Jekyll
  module Algolia
    class Base
      class NotIndexable < Base
        def generate_filters!; end
      end

      def self.make_for(page)
        if page.data['edition']
          Doc.new(page)
        elsif page.url.start_with?('/hub')
          Hub.new(page)
        elsif page.url == '/'
          Home.new(page)
        else
          NotIndexable.new(page)
        end
      end

      def initialize(page)
        @page = page
      end

      def generate_filters!
        return unless optional_filters

        @page.data['algolia'] = {
          'optional_filters' => optional_filters,
          'facet_filters' => facet_filters
        }
      end

      def optional_filters
        @optional_filters ||= products
                              .reverse
                              .map
                              .with_index(1) { |v, i| "'product:#{v}<score=#{i}>'" }.join(', ')
      end

      def facet_filters
        "'version:#{version}'"
      end
    end
  end
end

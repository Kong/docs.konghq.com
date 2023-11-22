# frozen_string_literal: true

module Jekyll
  module Algolia
    class Doc < Base
      def products
        @products ||= FILTERS[edition]
      end

      def version
        return 'latest' if latest_version?

        case edition
        when 'gateway', 'kubernetes-ingress-controller', 'deck', 'gateway-operator'
          Gem::Version.correct?(page_version) ? page_version : 'latest'
        when 'mesh'
          Versions::Mesh.indexed_version(page_version)
        else
          'latest'
        end
      end

      def edition
        @edition ||= @page.data['edition']
      end

      private

      def latest_version?
        @page.data['is_latest'] || page_version.nil?
      end

      def page_version
        @page_version ||= @page.data['kong_version']
      end
    end
  end
end

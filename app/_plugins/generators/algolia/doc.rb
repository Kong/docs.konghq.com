# frozen_string_literal: true

module Jekyll
  module Algolia
    class Doc < Base
      FILTERS = {
        'contributing' => ['Contribution guidelines'],
        'deck' => ['deck'],
        'gateway' => ['Kong Gateway', 'Plugin Hub', 'deck'],
        'gateway-operator' => ['Kong Gateway Operator'],
        'konnect' => ['Kong Konnect', 'Plugin Hub', 'deck'],
        'kubernetes-ingress-controller' => ['Kong Ingress Controller', 'Kong Konnect'],
        'mesh' => ['Kong Mesh']
      }.freeze

      def products
        @products ||= FILTERS[edition]
      end

      def version # rubocop:disable Metrics/MethodLength
        return 'latest' if latest_version?

        case edition
        when 'gateway'
          Versions::Gateway.indexed_version(page_version)
        when 'kubernetes-ingress-controller'
          Versions::KIC.indexed_version(page_version)
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
        @page.data['is_latest'] || page_version.nil? || !Gem::Version.correct?(page_version)
      end

      def page_version
        @page_version ||= @page.data['kong_version']
      end
    end
  end
end

# frozen_string_literal: true

module Jekyll
  module Algolia
    class Home < Base
      FILTERS = ['Kong Gateway', 'Kong Konnect', 'Kong Mesh'].freeze

      def products
        @products ||= FILTERS
      end

      def version
        'latest'
      end
    end
  end
end

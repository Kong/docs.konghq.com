# frozen_string_literal: true

module Jekyll
  module Algolia
    class Hub < Base
      def products
        @products ||= FILTERS['hub']
      end

      def version
        if @page.data['is_latest']
          'latest'
        else
          @page.data['version']
        end
      end

      private

      def product_facet
        @product_facet ||= products.first
      end
    end
  end
end

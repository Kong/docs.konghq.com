# frozen_string_literal: true

module Jekyll
  module Algolia
    class OasPage < Base
      def products
        @products ||= FILTERS['oas']
      end

      def version
        if @page.data['is_latest']
          'latest'
        else
          @page.data['version']
        end
      end
    end
  end
end

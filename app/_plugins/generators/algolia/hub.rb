# frozen_string_literal: true

module Jekyll
  module Algolia
    class Hub < Base
      FILTERS = ['Plugin Hub'].freeze

      def products
        @products ||= FILTERS
      end

      def version
        if @page.data['is_latest']
          'latest'
        else
          Versions::Gateway.indexed_version(@page.data['version'])
        end
      end
    end
  end
end

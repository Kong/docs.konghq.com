# frozen_string_literal: true

module Jekyll
  module Algolia
    class Home < Base
      def products
        @products ||= FILTERS['home']
      end

      def version
        'latest'
      end
    end
  end
end

# frozen_string_literal: true

module Jekyll
  module Drops
    module Oas
      class Product < Liquid::Drop
        def initialize(product:) # rubocop:disable Lint/MissingSuper
          @product = product
        end

        def title
          @title ||= @product.fetch('title')
        end

        def description
          @description ||= @product.fetch('description')
        end

        def latest_version
          @latest_version ||= @product.fetch('latestVersion').fetch('name')
        end

        def id
          @id ||= @product.fetch('id')
        end

        def as_json
          { id: }
        end

        def deprecated?
          version = @product.fetch('versions', []).detect do |v|
            v.fetch('name') == latest_version
          end

          version&.fetch('deprecated')
        end
      end
    end
  end
end

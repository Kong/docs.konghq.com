# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      class Breadcrumb < Liquid::Drop
        def initialize(attrs) # rubocop:disable Lint/MissingSuper
          @attrs = attrs
        end

        def url
          @url ||= @attrs[:url]
        end

        def text
          @text ||= @attrs[:text]
        end
      end

      class Breadcrumbs < Liquid::Drop
        def initialize(breadcrumbs) # rubocop:disable Lint/MissingSuper
          @breadcrumbs = breadcrumbs
        end

        def breadcrumbs
          @breadcrumbs.map { |b| Breadcrumb.new(b) }
        end
      end
    end
  end
end

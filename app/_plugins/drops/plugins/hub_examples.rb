# frozen_string_literal: true

require 'forwardable'

module Jekyll
  module Drops
    module Plugins
      class Example < Liquid::Drop
        attr_reader :example, :type

        def initialize(type:, example:) # rubocop:disable Lint/MissingSuper
          @type = type
          @example = example
        end

        def curl
          @curl ||= Examples::Curl.new(type:, example:)
        end

        def yaml
          @yaml ||= Examples::Yaml.new(type:, example:)
        end

        def kubernetes
          @kubernetes ||= Examples::Yaml.new(type:, example:)
        end

        def kong_manager
          @kong_manager ||= Examples::KongManager.new(type:, example:)
        end

        def plugin_name
          @plugin_name ||= @example.fetch('name')
        end
      end

      class HubExamples < Liquid::Drop
        extend Forwardable

        def_delegators :@schema, :enable_on_consumer?, :enable_on_route?,
                       :enable_on_service?, :example

        def initialize(schema:) # rubocop:disable Lint/MissingSuper
          @schema = schema
        end

        def render?
          !example.nil?
        end

        def navtabs?
          enable_on_consumer? || enable_on_service? || enable_on_route?
        end

        def consumer
          return unless enable_on_consumer?

          @consumer ||= Example.new(type: 'consumer', example:)
        end

        def global
          @global ||= Example.new(type: 'global', example:)
        end

        def route
          return unless enable_on_route?

          @route ||= Example.new(type: 'route', example:)
        end

        def service
          return unless enable_on_service?

          @service ||= Example.new(type: 'service', example:)
        end
      end
    end
  end
end

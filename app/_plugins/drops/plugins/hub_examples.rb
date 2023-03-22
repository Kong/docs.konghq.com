# frozen_string_literal: true

require 'forwardable'

module Jekyll
  module Drops
    module Plugins
      class Example < Liquid::Drop
        attr_reader :config, :example, :type

        def initialize(type:, example:, config:) # rubocop:disable Lint/MissingSuper
          @type = type
          @example = example
          @config = config
        end

        def curl
          @curl ||= Examples::Curl.new(type:, example:, config:)
        end

        def yaml
          @yaml ||= Examples::Yaml.new(type:, example:, config:)
        end

        def kubernetes
          @kubernetes ||= Examples::Yaml.new(type:, example:, config:)
        end

        def kong_manager
          @kong_manager ||= Examples::KongManager.new(type:, example:, config:)
        end

        def plugin_name
          @plugin_name ||= @example.fetch('name')
        end
      end

      class HubExamples < Liquid::Drop
        extend Forwardable

        def_delegators :@schema, :enable_on_consumer?, :enable_on_route?,
                       :enable_on_service?

        attr_reader :example, :config

        def initialize(config:, example:, schema:) # rubocop:disable Lint/MissingSuper
          @config = config
          @example = example
          @schema = schema
        end

        def render?
          @config['examples'].nil? || @config['examples']
        end

        def navtabs?
          @schema.enable_on_consumer? ||
            @schema.enable_on_service? ||
            @schema.enable_on_route?
        end

        def consumer
          return unless @schema.enable_on_consumer?

          @consumer ||= Example.new(type: 'consumer', example:, config:)
        end

        def global
          @global ||= Example.new(type: 'global', example:, config:)
        end

        def route
          return unless @schema.enable_on_route?

          @route ||= Example.new(type: 'route', example:, config:)
        end

        def service
          return unless @schema.enable_on_service?

          @service ||= Example.new(type: 'service', example:, config:)
        end
      end
    end
  end
end

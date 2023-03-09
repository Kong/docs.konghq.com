# frozen_string_literal: true

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
        attr_reader :example, :config

        def initialize(config:, example:) # rubocop:disable Lint/MissingSuper
          @config = config
          @example = example
        end

        def render?
          @config['examples'].nil? || @config['examples']
        end

        def navtabs?
          [@config['service_id'], @config['route_id'], @config['consumer_id']].any?
        end

        def consumer
          return unless @config['consumer_id']

          @consumer ||= Example.new(type: 'consumer', example:, config:)
        end

        def global
          @global ||= Example.new(type: 'global', example:, config:)
        end

        def route
          return unless @config['route_id']

          @route ||= Example.new(type: 'route', example:, config:)
        end

        def service
          return unless @config['service_id']

          @service ||= Example.new(type: 'service', example:, config:)
        end
      end
    end
  end
end

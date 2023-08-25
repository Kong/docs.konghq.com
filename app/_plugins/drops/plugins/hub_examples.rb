# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      class Example < Liquid::Drop
        attr_reader :example, :type

        def initialize(type:, example:, formats:) # rubocop:disable Lint/MissingSuper
          @type = type
          @example = example
          @formats = formats
        end

        def render_curl?
          @formats.include?(:curl)
        end

        def render_konnect?
          @formats.include?(:konnect)
        end

        def render_yaml?
          @formats.include?(:yaml)
        end

        def render_kubernetes?
          @formats.include?(:kubernetes)
        end

        def curl
          @curl ||= Examples::Curl.new(type:, example:)
        end

        def konnect
          @konnect ||= Examples::Konnect.new(type:, example:)
        end

        def yaml
          @yaml ||= Examples::Yaml.new(type:, example:)
        end

        def kubernetes
          @kubernetes ||= Examples::Yaml.new(type:, example:)
        end

        def plugin_name
          @plugin_name ||= @example.fetch('name')
        end
      end

      class HubExamples < Liquid::Drop
        attr_reader :example, :formats

        def initialize(schema:, example:, targets:, formats:) # rubocop:disable Lint/MissingSuper
          @schema = schema
          @example = example
          @targets = targets
          @formats = formats
        end

        def render?
          !@example.nil?
        end

        def navtabs?
          enable_on_consumer? || enable_on_consumer_group? || enable_on_service? || enable_on_route?
        end

        def enable_on_consumer?
          @targets.include?(:consumer) && @schema.enable_on_consumer?
        end

        def enable_on_consumer_group?
          @targets.include?(:consumer_group) && @schema.enable_on_consumer_group?
        end

        def enable_on_route?
          @targets.include?(:route) && @schema.enable_on_route?
        end

        def enable_on_service?
          @targets.include?(:service) && @schema.enable_on_service?
        end

        def enable_globally?
          @targets.include?(:global)
        end

        def consumer
          return unless enable_on_consumer?

          @consumer ||= Example.new(type: 'consumer', example:, formats:)
        end

        def global
          @global ||= Example.new(type: 'global', example:, formats:)
        end

        def route
          return unless enable_on_route?

          @route ||= Example.new(type: 'route', example:, formats:)
        end

        def service
          return unless enable_on_service?

          @service ||= Example.new(type: 'service', example:, formats:)
        end

        def consumer_group
          return unless enable_on_consumer_group?

          @consumer_group ||= Example.new(type: 'consumer_group', example:, formats:)
        end
      end
    end
  end
end

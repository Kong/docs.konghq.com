# frozen_string_literal: true

# There are also oauth2, acl and mtls-auth but I don't have examples of how to use them yet
AUTH_PLUGINS = %w[basic-auth hmac-auth jwt key-auth].freeze

module Jekyll
  module Drops
    module Plugins
      class Example < Liquid::Drop
        attr_reader :example, :type

        def initialize(schema:, type:, example:, formats:) # rubocop:disable Lint/MissingSuper
          @schema = schema
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

        def render_terraform?
          kong_plugin? && plugin_config? && @formats.include?(:terraform)
        end

        def kong_plugin?
          @schema.is_a?(PluginSingleSource::Plugin::Schemas::Kong)
        end

        def plugin_config?
          !!@example.fetch('config', nil)
        end

        def auth_plugin?
          AUTH_PLUGINS.include?(plugin_name)
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

        def terraform
          @terraform ||= Examples::Terraform.new(type:, example:)
        end

        def plugin_name
          @plugin_name ||= @example.fetch('name')
        end

        def auth
          @auth ||= Examples::AuthPlugins::Base.make_for(plugin_name)
        end

        def auth_fields
          auth.fields
        end

        def auth_next_steps_url
          auth.next_steps_url
        end
      end

      class HubExamples < Liquid::Drop
        attr_reader :schema, :example, :formats

        def initialize(schema:, metadata:, example:, targets:, formats:) # rubocop:disable Lint/MissingSuper
          @schema = schema
          @metadata = metadata
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
          global = @metadata['global']

          # Default to true if the key is not present
          global = true unless @metadata.key?('global')

          @targets.include?(:global) && global
        end

        def consumer
          return unless enable_on_consumer?

          @consumer ||= Example.new(schema:, type: 'consumer', example:, formats:)
        end

        def global
          return unless enable_globally?

          @global ||= Example.new(schema:, type: 'global', example:, formats:)
        end

        def route
          return unless enable_on_route?

          @route ||= Example.new(schema:, type: 'route', example:, formats:)
        end

        def service
          return unless enable_on_service?

          @service ||= Example.new(schema:, type: 'service', example:, formats:)
        end

        def consumer_group
          return unless enable_on_consumer_group?

          @consumer_group ||= Example.new(schema:, type: 'consumer_group', example:, formats:)
        end
      end
    end
  end
end

# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    module Schemas
      class Base
        NO_SERVICE = { 'service' => { 'type' => 'foreign', 'reference' => 'services', 'eq' => nil } }.freeze

        NO_ROUTE = { 'route' => { 'type' => 'foreign', 'reference' => 'routes', 'eq' => nil } }.freeze

        NO_CONSUMER = { 'consumer' => { 'type' => 'foreign', 'reference' => 'consumers', 'eq' => nil } }.freeze

        # Skips plugin versions older than 2.3.x for which
        # the docker image isn't working
        def self.make_for(vendor:, name:, version:)
          if vendor == 'kong-inc'
            if Utils::Version.to_version(version) <= Utils::Version.to_version('2.3.x')
              NullSchema.new(plugin_name: name, vendor:, version:)
            else
              Kong.new(plugin_name: name, vendor:, version:)
            end
          else
            ThirdParty.new(plugin_name: name, vendor:, version:)
          end
        end

        attr_reader :plugin_name, :vendor, :version

        def initialize(plugin_name:, vendor:, version:)
          @plugin_name = plugin_name
          @vendor = vendor
          @version = version
        end

        def fields
          @fields ||= schema.fetch('fields', {})
        end

        def config
          @config ||= begin
            field = fields.detect { |f| f.key?('config') }
            (field && field['config']) || {}
          end
        end

        def schema
          @schema ||= JSON.parse(File.read(file_path))
        end

        def example
          @example ||= Examples::Base
                       .make_for(vendor:, name: plugin_name, version:)
                       .example
        end

        def protocols
          @protocols ||= begin
            protocols = fields.detect { |f| f.key?('protocols') }&.values&.first || {}
            protocols.dig('elements', 'one_of') || []
          end
        end

        def enable_on_consumer?
          field = fields.detect { |f| f.key?('consumer') }
          return true unless field

          field != NO_CONSUMER
        end

        def enable_on_service?
          field = fields.detect { |f| f.key?('service') }
          return true unless field

          field != NO_SERVICE
        end

        def enable_on_route?
          field = fields.detect { |f| f.key?('route') }
          return true unless field

          field != NO_ROUTE
        end

        def empty?
          schema.empty?
        end
      end
    end
  end
end

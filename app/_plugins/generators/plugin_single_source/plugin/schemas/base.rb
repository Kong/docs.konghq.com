# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    module Schemas
      class Base
        NO_SERVICE = { 'service' => { 'type' => 'foreign', 'reference' => 'services', 'eq' => nil } }.freeze

        NO_ROUTE = { 'route' => { 'type' => 'foreign', 'reference' => 'routes', 'eq' => nil } }.freeze

        NO_CONSUMER = { 'consumer' => { 'type' => 'foreign', 'reference' => 'consumers', 'eq' => nil } }.freeze

        NO_CONSUMER_GROUP = { 'consumer_group' => { 'type' => 'foreign', 'reference' => 'consumer_groups',
                                                    'eq' => nil } }.freeze

        # Skips plugin versions older than 2.3.x for which
        # the docker image isn't working
        def self.make_for(vendor:, name:, version:, site:)
          if vendor == 'kong-inc'
            if Utils::Version.to_version(version) <= Utils::Version.to_version('2.3.x')
              NullSchema.new(plugin_name: name, vendor:, version:, site:)
            else
              Kong.new(plugin_name: name, vendor:, version:, site:)
            end
          else
            ThirdParty.new(plugin_name: name, vendor:, version:, site:)
          end
        end

        attr_reader :plugin_name, :vendor, :version

        def initialize(plugin_name:, vendor:, version:, site:)
          @plugin_name = plugin_name
          @vendor = vendor
          @version = version
          @site = site
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

        def example_file_path
          @example_file_path ||= Examples::Base
                                 .make_for(vendor:, name: plugin_name, version:)
                                 .file_path
        end

        def protocols_field
          @protocols_field ||= fields.detect { |f| f.key?('protocols') }&.values&.first || {}
        end

        def protocols
          @protocols ||= protocols_field.dig('elements', 'one_of') || []
        end

        def enable_on_consumer?
          field = fields.detect { |f| f.key?('consumer') }
          return true unless field

          !field_no_def?('consumer', field, NO_CONSUMER)
        end

        def enable_on_consumer_group?
          # Consumer Groups support for plugins was introduced in 3.4.x
          return false if Utils::Version.to_version(@version) < Utils::Version.to_version('3.4.x')

          field = fields.detect { |f| f.key?('consumer_group') }
          return true unless field

          !field_no_def?('consumer_group', field, NO_CONSUMER_GROUP)
        end

        def enable_on_service?
          field = fields.detect { |f| f.key?('service') }
          return true unless field

          !field_no_def?('service', field, NO_SERVICE)
        end

        def enable_on_route?
          field = fields.detect { |f| f.key?('route') }
          return true unless field

          !field_no_def?('route', field, NO_ROUTE)
        end

        def empty?
          schema.empty?
        end

        private

        def field_no_def?(key, field, no_def)
          no_def[key].all? do |k, v|
            field[key][k] == v
          end
        end
      end
    end
  end
end

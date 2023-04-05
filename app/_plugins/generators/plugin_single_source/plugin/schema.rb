# frozen_string_literal: true

require 'json'

module PluginSingleSource
  module Plugin
    class Schema
      NO_SERVICE = {
        'service' => {
          'type' => 'foreign',
          'reference' => 'services',
          'eq' => nil
        }
      }.freeze
      NO_ROUTE = {
        'route' => {
          'type' => 'foreign',
          'reference' => 'routes',
          'eq' => nil
        }
      }.freeze
      NO_CONSUMER = {
        'consumer' => {
          'type' => 'foreign',
          'reference' => 'consumers',
          'eq' => nil
        }
      }.freeze

      SCHEMAS_PATH = 'app/_src/.repos/kong-plugins/'

      attr_reader :plugin_name

      def initialize(plugin_name:, version:)
        @plugin_name = plugin_name
        @version = version
      end

      def schema
        @schema ||= JSON.parse(File.read(file_path))
      end

      def fields
        @fields ||= schema.fetch('fields')
      end

      def config
        @config ||= fields.detect { |f| f.key?('config') }['config']
      end

      def enable_on_consumer?
        fields.detect { |f| f.key?('consumer') } != NO_CONSUMER
      end

      def enable_on_service?
        fields.detect { |f| f.key?('service') } != NO_SERVICE
      end

      def enable_on_route?
        fields.detect { |f| f.key?('route') } != NO_ROUTE
      end

      def example
        @example ||= ExampleGenerator.new(schema: self).generate
      end

      def protocols
        @protocols ||= begin
          protocols = fields.detect { |f| f.key?('protocols') }&.values&.first || {}
          protocols.dig('elements', 'one_of') || []
        end
      end

      private

      def file_path
        @file_path ||= File.join(
          SCHEMAS_PATH,
          'schemas',
          @plugin_name,
          "#{release_version}.json"
        )
      end

      def release_version
        @version.split('.').first(2).join('.').concat('.x')
      end
    end

    class NullSchema < Schema
      def schema
        { 'fields' => [{ 'config' => { 'fields' => [] } }] }
      end
    end
  end
end

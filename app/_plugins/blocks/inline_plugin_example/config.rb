# frozen_string_literal: true

module Jekyll
  module InlinePluginExample
    class Config
      TARGETS = %i[service route consumer global consumer_group].freeze
      FORMATS = %i[curl konnect yaml kubernetes].freeze

      def initialize(config:, page:, site:)
        @config = config
        @page = page
        @site = site

        validate!
      end

      def title
        @title ||= @config['title']
      end

      # this must have the vendor
      def plugin
        @plugin ||= @config['plugin']
      end

      def targets
        # validate targets against the schema
        @targets ||= @config.fetch('targets', []).map(&:to_sym)
      end

      def formats
        @formats ||= @config.fetch('formats', []).map(&:to_sym)
      end

      def examples
        ::Jekyll::Drops::Plugins::HubExamples
          .new(schema:, example:, targets:, formats:)
      end

      def schema
        @schema ||= ::PluginSingleSource::Plugin::Schemas::Base
                    .make_for(vendor:, name: plugin_name, version:, site: @site)
      end

      def example
        @example ||= { 'name' => @config['name'], 'config' => @config['config'] }
      end

      private

      def validate!
        invalid_target = targets.detect { |t| !TARGETS.include?(t) }
        if invalid_target
          raise ArgumentError, "Invalid target `#{invalid_target}` for plugin example. Supported targets: #{TARGETS}"
        end

        invalid_format = formats.detect { |f| !FORMATS.include?(f) }
        return unless invalid_format

        raise ArgumentError, "Invalid format` #{invalid_format}` for plugin example. Supported formats: #{FORMATS}"
      end

      def vendor
        @vendor ||= plugin.split('/').first
      end

      def plugin_name
        @plugin_name ||= plugin.split('/').last
      end

      def version
        @version ||= @page['release']&.value || @page['version']
      end
    end
  end
end

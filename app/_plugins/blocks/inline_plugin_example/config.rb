# frozen_string_literal: true

module Jekyll
  module InlinePluginExample
    class Config
      TARGETS = %i[service route consumer global].freeze
      FORMATS = %i[curl yaml kubernetes].freeze

      def initialize(config:, page:)
        @config = config
        @page = page

        validate!
      end

      def name
        @name ||= @config['name']
      end

      # this must have the vendor
      def plugin
        @plugin ||= @config['plugin']
      end

      def example_name
        @example_name ||= @config['example']
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
                    .make_for(vendor:, name: plugin_name, version:)
      end

      def example
        @example ||= ::PluginSingleSource::Plugin::Examples::Base
                     .make_for(vendor:, name: plugin_name, version:, example_name:)
                     .example
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
        @version ||= @page['kong_version']
      end
    end
  end
end

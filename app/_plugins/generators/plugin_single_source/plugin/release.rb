# frozen_string_literal: true

require 'forwardable'
require 'yaml'

module PluginSingleSource
  module Plugin
    class Release
      extend Forwardable

      attr_reader :version, :site

      def_delegators :@plugin, :ext_data, :vendor, :name, :dir

      def initialize(site:, version:, plugin:, is_latest:)
        @site = site
        @version = version
        @plugin = plugin
        @is_latest = is_latest
      end

      def metadata
        @metadata ||= Metadata.new(release: self, site:).metadata
      end

      def latest?
        @is_latest
      end

      def how_tos
        @how_tos ||= Dir.glob(File.expand_path('how-to/**/*.md', pages_source_path)).map do |file|
          Pages::HowTo.make_for(
            release: self,
            file: file.gsub(pages_source_path, ''),
            source_path: pages_source_path
          )
        end.compact
      end

      def references
        return nil unless File.exist?(File.join(plugin_base_path, '_api.md'))

        @references ||= Pages::References.new(
          release: self,
          file: '_api.md',
          source_path: plugin_base_path
        )
      end

      def configuration
        return nil if schema.empty?

        @configuration ||= Pages::Configuration.new(
          release: self,
          file: schema.relative_file_path,
          source_path: ''
        )
      end

      def configuration_examples
        return nil if schema.empty? || (schema && !schema.example)

        @configuration_examples ||= Pages::ConfigurationExamples.new(
          release: self,
          file: schema.example_file_path.gsub('app/', ''),
          source_path: ''
        )
      end

      def overviews
        @overviews ||= Dir.glob(File.expand_path('overview/**/*.md', pages_source_path)).map do |file|
          Pages::Overview.make_for(
            release: self,
            file: file.gsub(pages_source_path, ''),
            source_path: pages_source_path
          )
        end.compact
      end

      def changelog
        return nil unless File.exist?(File.join(plugin_base_path, '_changelog.md'))

        @changelog ||= Pages::Changelog.new(
          release: self,
          file: '_changelog.md',
          source_path: plugin_base_path
        )
      end

      def troubleshooting
        @troubleshooting ||= Pages::Troubleshooting.make_for(
          release: self,
          file: nil,
          source_path: pages_source_path
        )
      end

      def generate_pages
        PagesBuilder.new(self).run
      end

      def plugin_base_path
        @plugin_base_path ||= File.expand_path(
          "#{Generator::PLUGINS_FOLDER}/#{dir}/",
          @site.source
        )
      end

      def pages_source_path
        @pages_source_path ||= "#{plugin_base_path}/"
      end

      def schema
        @schema ||= Schemas::Base.make_for(vendor:, name:, version:, site:)
      end

      def enterprise_plugin?
        !!metadata['enterprise'] && !!!metadata['free']
      end
    end
  end
end

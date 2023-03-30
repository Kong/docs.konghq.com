# frozen_string_literal: true

require 'forwardable'
require 'yaml'

module PluginSingleSource
  module Plugin
    class Release
      extend Forwardable

      attr_reader :version, :source, :site

      def_delegators :@plugin, :ext_data, :vendor, :name, :dir, :set_version?

      def initialize(site:, version:, plugin:, source:, is_latest:)
        @site = site
        @version = version
        @plugin = plugin
        @source = source
        @is_latest = is_latest

        validate_source!
      end

      def configuration_parameters_table
        @configuration_parameters_table ||= SafeYAML.load(
          Utils::SafeFileReader.read(
            file_name: '_configuration.yml',
            source_path: pages_source_path
          )
        ) || {}
      end

      def frontmatter
        @frontmatter ||= parsed_file.frontmatter
      end

      def latest?
        @is_latest
      end

      def how_tos
        @how_tos ||= Dir.glob(File.expand_path('how-to/**/*.md', pages_source_path)).map do |file|
          Pages::HowTo.new(
            release: self,
            file: file.gsub(pages_source_path, ''),
            source_path: pages_source_path
          )
        end
      end

      def references
        @references ||= Dir.glob(File.expand_path('reference/**/*.md', pages_source_path)).map do |file|
          Pages::Reference.new(
            release: self,
            file: file.gsub(pages_source_path, ''),
            source_path: pages_source_path
          )
        end
      end

      def overview_page
        @overview_page ||= Pages::Overview.new(
          release: self,
          file: '_index.md',
          source_path: pages_source_path
        )
      end

      def changelog
        @changelog ||= Pages::Changelog.new(
          release: self,
          file: '_changelog.md',
          source_path: plugin_base_path
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
        @pages_source_path ||= if @source == '_index'
                                 "#{plugin_base_path}/"
                               else
                                 "#{plugin_base_path}/#{@source}/"
                               end
      end

      def schema
        # XXX: Quick hack to make the site build
        # Skips third-party plugins and versions older than 2.3.x for which
        # the docker image isn't working
        @schema ||= if vendor != 'kong-inc' ||
                       Utils::Version.to_version(version) <= Utils::Version.to_version('2.3.x') ||
                       %w[app-dynamics serverless-functions].include?(name)
                      NullSchema.new(plugin_name: name, version:)
                    else
                      Schema.new(plugin_name: name, version:)
                    end
      end

      private

      def parsed_file
        @parsed_file ||= ::Utils::FrontmatterParser.new(
          File.read(File.expand_path('_index.md', pages_source_path))
        )
      end

      def validate_source!
        return if @source.start_with?('_')

        raise ArgumentError,
              "Plugin source files must start with an _ to prevent Jekyll from rendering them directly. Please fix [#{@source}] in [#{dir}]" # rubocop:disable Layout/LineLength
      end
    end
  end
end

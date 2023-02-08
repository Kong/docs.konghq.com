# frozen_string_literal: true

require 'forwardable'

module PluginSingleSource
  module Plugin
    class Release
      extend Forwardable

      attr_reader :version, :source

      def_delegators :@plugin, :ext_data, :vendor, :name, :dir, :set_version?

      def initialize(site:, version:, plugin:, source:, is_latest:)
        @site = site
        @version = version
        @plugin = plugin
        @source = source
        @is_latest = is_latest
      end

      def configuration_parameters_table
        @configuration_parameters_table ||= SafeYAML.load(
          File.read(File.expand_path('_configuration.yml', pages_source_path))
        ) || {}
      end

      def changelog
        @changelog ||= File.read(
          File.expand_path('_changelog.md', plugin_base_path)
        )
      end

      def how_to
        @how_to ||= File.read(
          File.expand_path('how-to/_index.md', pages_source_path)
        )
      end

      def overview
        @overview ||= File.read(source_path)
      end

      def frontmatter
        @frontmatter ||= parsed_file.frontmatter
      end

      def latest?
        @is_latest
      end

      def content
        @content ||= <<~CONTENT
          #{how_to}

          #{changelog}
        CONTENT
      end

      def data
        @data ||= PageData.generate(release: self)
      end

      def source_file
        @source_file ||= source_path.gsub("#{@site.source}/", '')
      end

      private

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

      def parsed_file
        @parsed_file ||= ::Utils::FrontmatterParser.new(overview)
      end

      def source_path
        @source_path ||= File.expand_path('_index.md', pages_source_path)
      end
    end
  end
end

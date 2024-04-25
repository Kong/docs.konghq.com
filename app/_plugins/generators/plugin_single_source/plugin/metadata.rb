# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    class Metadata
      def initialize(release:, site:)
        @release = release
        @site = site
      end

      def metadata
        @metadata ||= if i18n_file.exists?
                        build_metadata
                      else
                        {}
                      end
      end

      private

      def i18n_file
        @i18n_file ||= Jekyll::GeneratorSingleSource::I18nFile.new(
          file: file_path,
          src_path: '',
          locale: @site.config['locale'],
          site: @site
        )
      end

      def file_path
        @file_path ||= Utils::SingleSourceFileFinder
                       .find(file_path: "#{@release.pages_source_path}/_metadata/", version: @release.version)
                       .gsub("#{@site.source}/", '')
      end

      def build_metadata
        # Use english version as source of truth,
        # pull only the description from the translations
        source = SafeYAML.load(File.read(i18n_file.full_file_path_in_default_locale))
        localized = SafeYAML.load(File.read(i18n_file.full_file_path_in_locale))
        source.merge('desc' => localized['desc'])
      end
    end
  end
end

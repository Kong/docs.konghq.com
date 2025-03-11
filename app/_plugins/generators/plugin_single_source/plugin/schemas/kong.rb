# frozen_string_literal: true

require 'json'

module PluginSingleSource
  module Plugin
    module Schemas
      class Kong < Base
        SCHEMAS_PATH = '_src/.repos/kong-plugins/schemas/'

        def file_path
          @file_path ||= i18n_file.full_file_path_in_locale
        end

        def relative_file_path
          @relative_file_path ||= i18n_file.relative_file_path
        end

        def release_version
          version.split('.').first(2).join('.').concat('.x')
        end

        private

        def plugin_folder
          plugin_name
        end

        def i18n_file
          @i18n_file ||= Jekyll::GeneratorSingleSource::I18nFile.new(
            file: File.join(plugin_folder, "#{release_version}.json"),
            src_path: SCHEMAS_PATH,
            locale: @site.config['locale'],
            site: @site
          )
        end
      end
    end
  end
end

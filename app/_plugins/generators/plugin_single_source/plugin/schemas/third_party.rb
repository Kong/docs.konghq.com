# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    module Schemas
      class ThirdParty < Base
        SCHEMAS_PATH = '_hub'

        def file_path
          @file_path ||= i18n_file.full_file_path_in_locale
        end

        def relative_file_path
          @relative_file_path ||= i18n_file.relative_file_path
        end

        def i18n_file
          @i18n_file ||= Jekyll::GeneratorSingleSource::I18nFile.new(
            file: File.join(vendor, plugin_name, 'schemas/_index.json'),
            src_path: SCHEMAS_PATH,
            locale: @site.config['locale'],
            site: @site
          )
        end
      end
    end
  end
end

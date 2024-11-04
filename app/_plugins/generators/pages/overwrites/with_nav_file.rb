# frozen_string_literal: true

module Jekyll
  module Pages
    module Overwrites
      class WithNavFile < Base
        private

        def set_i18n_data # rubocop:disable Metrics/AbcSize
          # If the nav file hasn't been translated, use the english version of the file and nav
          if docs_nav.missing_translation?
            @page.data['nav_items'] = docs_nav.nav_items_in_locale(I18n.default_locale.to_s)
            @page.data.merge!(Jekyll::Pages::TranslationMissingData.new(@site).data)
          else
            @page.data['nav_items'] = docs_nav.nav_items_in_locale(@site.config['locale'])
          end
        end

        def docs_nav
          @docs_nav ||= Jekyll::GeneratorSingleSource::GeneratorConfig
                        .new(@site)
                        .build_docs_nav(edition:)
        end

        def set_missing_translation_data
          @page.data.merge!(Jekyll::Pages::TranslationMissingData.new(@site).data)
          @page.data['nav_items'] = docs_nav.nav_items_in_locale(I18n.default_locale.to_s)
        end

        def file_path
          if docs_nav.missing_translation?
            # If the nav file hasn't been translated, use the english version of the file and nav
            i18n_file.full_file_path_in_default_locale
          else
            # If the nav file has been translated, use the translated version of the file and nav
            i18n_file.full_file_path_in_locale
          end
        end
      end
    end
  end
end

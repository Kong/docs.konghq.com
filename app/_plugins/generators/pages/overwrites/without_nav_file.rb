# frozen_string_literal: true

module Jekyll
  module Pages
    module Overwrites
      class WithoutNavFile < Base
        private

        def set_missing_translation_data
          @page.data.merge!(Jekyll::Pages::TranslationMissingData.new(@site).data)
        end

        def file_path
          i18n_file.full_file_path_in_locale
        end
      end
    end
  end
end

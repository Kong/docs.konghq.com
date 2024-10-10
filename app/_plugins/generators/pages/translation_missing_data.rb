# frozen_string_literal: true

module Jekyll
  module Pages
    class TranslationMissingData
      def initialize(site)
        @site = site
      end

      def data
        if @site.config['locale'] == I18n.default_locale
          { 'locale' => I18n.default_locale.to_s }
        else
          { 'translation_fallback' => true, 'locale' => I18n.default_locale.to_s }
        end
      end
    end
  end
end

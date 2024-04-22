# frozen_string_literal: true

require_relative 'overwrites/base'

module Jekyll
  module Pages
    class StaticPageMissingTranslation
      def initialize(site:, page:)
        @site = site
        @page = page
      end

      def process!
        return if @site.config['locale'] == I18n.default_locale.to_s
        return if @page.url.start_with?('/assets/')

        check_for_translated_version
      end

      def check_for_translated_version
        return if @page.is_a?(Jekyll::GeneratorSingleSource::SingleSourcePage)
        return if @page.is_a?(PluginSingleSource::SingleSourcePage)

        Overwrites::Base.make_for(site: @site, page: @page).process!
      end
    end
  end
end

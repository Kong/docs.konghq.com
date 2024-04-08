# frozen_string_literal: true

require_relative 'productable'

module Jekyll
  module Pages
    class StaticPageMissingTranslation
      include Jekyll::Pages::Productable

      class OverridePageWithTranslatedContent
        def initialize(site:, page:, i18n_file:)
          @site = site
          @page = page
          @i18n_file = i18n_file
          @data = {}
        end

        def process! # rubocop:disable Metrics/AbcSize
          content = File.read(@i18n_file.full_file_path_in_locale)
          if content =~ Jekyll::Document::YAML_FRONT_MATTER_REGEXP
            content = Regexp.last_match.post_match
            @data = SafeYAML.load(Regexp.last_match(1))
          end

          # XXX-i18n what about the sidenav?
          @page.content = content
          @page.data.merge!(@data)
          @page.data['locale'] = @site.config['locale']
          @page.data['full_file_path_in_locale'] = @i18n_file.full_file_path_in_locale
        end
      end

      def initialize(site:, page:)
        @site = site
        @page = page
      end

      def process!
        return if @site.config['locale'] == I18n.default_locale.to_s
        return if @page.url.start_with?('/assets/')

        check_for_translated_version
      end

      def check_for_translated_version # rubocop:disable Metrics/MethodLength
        return if @page.is_a?(Jekyll::GeneratorSingleSource::SingleSourcePage)
        return if @page.is_a?(PluginSingleSource::SingleSourcePage)

        i18n_file = Jekyll::GeneratorSingleSource::I18nFile.new(
          file: @page.path,
          src_path: '',
          locale: @site.config['locale'],
          site: @site
        )
        if i18n_file.exists_in_locale?
          OverridePageWithTranslatedContent
            .new(site: @site, page: @page, i18n_file:).process!
        else
          @page.data.merge!(Jekyll::Pages::TranslationMissingData.new(@site).data)
        end
      end
    end
  end
end

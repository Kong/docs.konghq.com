# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    class Sidenav
      include Jekyll::TitleizeFilter

      def initialize(release)
        @release = release
      end

      def items
        [
          introduction,
          configuration,
          configuration_examples,
          references,
          changelog,
          troubleshooting
        ].compact
      end

      private

      def icon
        '/assets/images/icons/hub-layout/icn-how-to.svg'
      end

      def items_for(pages)
        pages.flatten.compact.map { |p| { 'text' => p.nav_title, 'url' => p.permalink } }
      end

      def nested_items(prefix, pages) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        pages
          .group_by { |h| Pathname.new(h.file.gsub("#{prefix}/", '')).dirname.to_s }
          .sort_by(&:first).rotate.to_h # Process nested folders first
          .each_with_object([]) do |(folder, nested_pages), array|
            if folder == '.'
              nested_pages.map do |page|
                array.push({ 'text' => page.nav_title, 'url' => page.permalink })
              end
            else
              array.push({ 'text' => titleize(folder), 'url' => nil,
                           'items' => nested_items("#{prefix}/#{folder}", nested_pages) })
            end
          end
      end

      def introduction
        {
          'title' => I18n.t('hub.sidebar.introduction', locale: translate_to),
          'items' => items_for(@release.overviews),
          'icon' => '/assets/images/icons/hub-layout/icn-overview.svg'
        }
      end

      def configuration
        return unless @release.configuration

        {
          'title' => @release.configuration.nav_title,
          'url' => @release.configuration.permalink,
          'icon' => '/assets/images/icons/hub-layout/icn-configuration.svg'
        }
      end

      def configuration_examples # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        return unless @release.configuration_examples

        if @release.vendor == 'kong-inc'
          {
            'title' => I18n.t('hub.sidebar.using_the_plugin', locale: translate_to),
            'items' => [
              { 'text' => @release.configuration_examples.nav_title,
                'url' => @release.configuration_examples.permalink },
              nested_items('how-to', @release.how_tos)
            ].flatten,
            'icon' => icon
          }
        else
          {
            'title' => @release.configuration_examples.nav_title,
            'url' => @release.configuration_examples.permalink,
            'icon' => icon
          }
        end
      end

      def references
        return unless @release.references

        {
          'title' => @release.references.nav_title,
          'url' => @release.references.permalink,
          'icon' => @release.references.icon
        }
      end

      def changelog
        return unless @release.changelog

        {
          'title' => @release.changelog.nav_title,
          'url' => @release.changelog.permalink,
          'icon' => @release.changelog.icon
        }
      end

      def troubleshooting
        return unless @release.troubleshooting

        {
          'title' => @release.troubleshooting.nav_title,
          'url' => @release.troubleshooting.permalink,
          'icon' => @release.troubleshooting.icon
        }
      end

      def translate_to
        @translate_to ||= @release.missing_translation? ? I18n.default_locale : I18n.locale
      end
    end
  end
end

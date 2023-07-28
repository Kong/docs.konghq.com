# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    class PagesBuilder
      include Jekyll::TitleizeFilter

      def initialize(release)
        @release = release
      end

      def run
        assign_sidenav

        jekyll_pages
      end

      def jekyll_pages
        pages.flatten.map(&:to_jekyll_page)
      end

      private

      def pages
        @pages ||= [
          @release.overviews,
          @release.configuration,
          @release.configuration_examples,
          @release.how_tos,
          @release.changelog,
          @release.references
        ].compact
      end

      def assign_sidenav
        pages.flatten.each { |p| p.sidenav = sidenav }
      end

      def sidenav
        @sidenav ||= ::Jekyll::Drops::Sidenav.new(
          sidenav_items,
          { 'plugin-key' => "#{@release.vendor}-#{@release.name}-#{@release.version}" }
        )
      end

      def icon
        '/assets/images/icons/documentation/hub/icn-how-to.svg'
      end

      def nested_items(prefix, pages) # rubocop:disable Metrics/MethodLength
        pages
          .group_by { |h| Pathname.new(h.file.gsub("#{prefix}/", '')).dirname.to_s }
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

      def sidenav_items # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        items = [
          { 'title' => 'Introduction',
            'items' => items_for(@release.overviews),
            'icon' => '/assets/images/icons/documentation/hub/icn-overview.svg' }
        ]

        if @release.configuration
          items.push({
                       'title' => @release.configuration.nav_title,
                       'url' => @release.configuration.permalink,
                       'icon' => '/assets/images/icons/documentation/hub/icn-configuration.svg'
                     })
        end

        if @release.configuration_examples
          if @release.vendor == 'kong-inc'
            items.push({
                         'title' => 'Using the plugin',
                         'items' => [
                           { 'text' => @release.configuration_examples.nav_title,
                             'url' => @release.configuration_examples.permalink },
                           nested_items('how-to', @release.how_tos)
                         ].flatten,
                         'icon' => icon
                       })
          else
            items.push({
                         'title' => @release.configuration_examples.nav_title,
                         'url' => @release.configuration_examples.permalink,
                         'icon' => icon
                       })
          end
        end

        if @release.references
          items.push({
                       'title' => @release.references.nav_title,
                       'url' => @release.references.permalink,
                       'icon' => @release.references.icon
                     })
        end

        if @release.changelog
          items.push({
                       'title' => @release.changelog.nav_title,
                       'url' => @release.changelog.permalink,
                       'icon' => @release.changelog.icon
                     })
        end

        items
      end
    end
  end
end

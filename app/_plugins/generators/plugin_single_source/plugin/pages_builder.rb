# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    class PagesBuilder
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
          @release.overview_page,
          @release.configuration,
          @release.configuration_examples,
          @release.how_tos,
          @release.changelog
        ].compact
      end

      def assign_sidenav
        pages.flatten.each { |p| p.sidenav = sidenav }
      end

      def sidenav
        @sidenav ||= ::Jekyll::Drops::Sidenav.new(sidenav_items)
      end

      def icon
        '/assets/images/icons/documentation/hub/icn-how-to.svg'
      end

      def items_for(pages)
        pages.compact.map { |p| { 'text' => p.nav_title, 'url' => p.permalink } }
      end

      def sidenav_items # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        items = [
          { 'title' => @release.overview_page.nav_title,
            'url' => @release.overview_page.permalink,
            'icon' => @release.overview_page.icon }
        ]

        if @release.configuration
          items.push({
                       'title' => @release.configuration.nav_title,
                       'items' => items_for([@release.configuration_examples]),
                       'icon' => @release.configuration.icon,
                       'url' => @release.configuration.permalink
                     })
        end

        if @release.how_tos.any?
          items.push({
                       'title' => 'Using the plugin',
                       'items' => items_for(@release.how_tos),
                       'icon' => icon
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

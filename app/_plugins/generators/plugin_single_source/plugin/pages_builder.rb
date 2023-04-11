# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    class PagesBuilder
      def initialize(release)
        @release = release
      end

      def run
        assign_sidenav

        pages
      end

      private

      def pages
        @pages ||= [
          @release.overview_page,
          @release.reference,
          @release.how_tos,
          @release.changelog
        ].flatten.map(&:to_jekyll_page)
      end

      def assign_sidenav
        pages.each { |p| p.data['sidenav'] = sidenav }
      end

      def sidenav
        @sidenav ||= ::Jekyll::Drops::Sidenav.new(sidenav_items)
      end

      def icon
        '/assets/images/icons/documentation/icn-references-color.svg'
      end

      def items_for(pages)
        pages.map { |p| { 'text' => p.nav_title, 'url' => p.permalink } }
      end

      def sidenav_items
        items = [
          { 'title' => 'Overview', 'url' => @release.overview_page.permalink, 'icon' => icon },
          { 'title' => 'Configuration Reference', 'url' => @release.reference.permalink, 'icon' => icon }
        ]

        if @release.how_tos.any?
          items.push({ 'title' => 'Using the plugin', 'items' => items_for(@release.how_tos), 'icon' => icon })
        end

        items.push({ 'title' => 'Changelog', 'url' => @release.changelog.permalink, 'icon' => icon })
        items
      end
    end
  end
end

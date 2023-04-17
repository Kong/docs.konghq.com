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
          @release.reference,
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
        pages.map { |p| { 'text' => p.nav_title, 'url' => p.permalink } }
      end

      def sidenav_items
        pages.each_with_object([]) do |page, items|
          if page.respond_to?(:each)
            items.push({ 'title' => 'Using the plugin', 'items' => items_for(page), 'icon' => icon }) if page.any?
          else
            items.push({ 'title' => page.nav_title, 'url' => page.permalink, 'icon' => page.icon })
          end
        end
      end
    end
  end
end

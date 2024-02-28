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
          Sidenav.new(@release).items,
          { 'plugin-key' => "#{@release.vendor}-#{@release.name}-#{@release.version}" }
        )
      end
    end
  end
end

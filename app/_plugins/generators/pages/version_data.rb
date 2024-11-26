# frozen_string_literal: true

require_relative 'productable'

module Jekyll
  module Pages
    class VersionData
      include Jekyll::Pages::Productable

      def initialize(site:, page:)
        @site = site
        @page = page
      end

      def process!
        @page.data['has_version'] = false

        return unless products.include?(product)

        set_data
      end

      private

      def set_data # rubocop:disable Metrics/AbcSize
        @page.data['edition'] ||= edition.name
        @page.data['releases'] = edition.releases.map(&:to_liquid)
        @page.data['releases_hash'] = edition.releases.map(&:to_h)
        @page.data['kong_latest'] = edition.latest_release&.to_h
        @page.data['has_version'] = version?

        set_release_data
      end

      def edition
        @edition ||= @site.data.dig('editions', product)
      end

      def set_release_data # rubocop:disable Metrics/AbcSize
        return unless version?

        @page.data['version'] ||= release.default_version
        @page.data['version_data'] = release.to_h
        @page.data['release'] ||= release.to_liquid

        # Add additional variables that are available in src pages
        # to pages in app
        @page.data['versions'] ||= release.versions

        # Add a `major_minor_version` property which is used for cloudsmith install pages
        @page.data['major_minor_version'] = release.value.gsub('.x', '').gsub('.', '')
      end

      def release
        @release ||= edition.releases.detect { |r| r.to_s == parts[1] }
      end

      def version?
        edition.releases.map(&:to_s).compact.include?(parts[1])
      end
    end
  end
end

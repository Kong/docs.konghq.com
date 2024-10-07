# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    class Base
      attr_reader :dir, :site

      def self.make_for(dir:, site:)
        versions_file = File.join(
          site.source, Generator::PLUGINS_FOLDER, dir, 'versions.yml'
        )

        if File.exist?(versions_file)
          Versioned.new(dir:, site:)
        else
          Unversioned.new(dir:, site:)
        end
      end

      def initialize(dir:, site:)
        @dir  = dir
        @site = site
      end

      def vendor
        @vendor ||= dir.split('/').first
      end

      def name
        @name ||= dir.split('/').last
      end

      def create_pages
        releases.map do |version, _|
          is_latest = latest?(version)
          # Skip if a markdown file exists for this version
          # and we're not generating the index version
          version_file = File.join(site.source, Generator::PLUGINS_FOLDER, dir, "#{version}.md")
          next if !is_latest && File.exist?(version_file)

          Release.new(plugin: self, version:, is_latest:, site:).generate_pages
        end.flatten.compact
      end

      def ext_data
        {}
      end

      private

      def latest?(version)
        max_release = gateway_releases.detect { |r| r['release'] == Utils::Version.to_release(max_version) }
        # Edge case for plugins that don't have releases
        # for which we still want to generate pages
        return true unless max_release

        latest_release = gateway_releases.detect { |r| r['latest'] }

        Utils::Version.to_semver(version) == if max_release && max_release['label']
                                               Utils::Version.to_semver(latest_release['release'])
                                             else
                                               Utils::Version.to_semver(max_release['release'])
                                             end
      end

      def max_version
        @max_version ||= releases
                         .map { |v| Utils::Version.to_semver(v) }
                         .max_by { |v| Gem::Version.new(v) }
      end

      def gateway_releases
        @gateway_releases ||= @site.data['kong_versions_gateway']
      end
    end
  end
end

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

      def create_pages # rubocop:disable Metrics/AbcSize
        releases.map do |version, _|
          is_latest = KongVersions.to_semver(version) == max_version
          # Skip if a markdown file exists for this version
          # and we're not generating the index version
          version_file = File.join(site.source, Generator::PLUGINS_FOLDER, dir, "#{version}.md")
          next if !is_latest && File.exist?(version_file)

          Release.new(plugin: self, source: sources[version], version:, is_latest:, site:).generate_pages
        end.flatten.compact
      end

      def sources
        @sources ||= Hash.new { |_k, _v| '_index' }
      end

      def set_version?
        releases.size > 1
      end

      def ext_data
        {}
      end

      private

      def max_version
        @max_version ||= releases
                         .map { |v| KongVersions.to_semver(v) }
                         .max_by { |v| Gem::Version.new(v) }
      end
    end
  end
end

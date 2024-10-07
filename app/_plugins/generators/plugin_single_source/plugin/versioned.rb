# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    class Versioned < Base
      def releases
        @releases ||= ReleasesGenerator.call(
          releases: supported_releases,
          replacements:
        )
      end

      def extension?
        true
      end

      def ext_data
        super.merge(
          'releases' => releases,
          'strategy' => data['strategy'],
          'overrides' => data['overrides'],
          'frontmatter' => data['frontmatter']
        )
      end

      private

      def data
        @data ||= SafeYAML.load(
          File.read(
            File.join(site.source, Generator::PLUGINS_FOLDER, dir, 'versions.yml')
          )
        )
      end

      def supported_releases # rubocop:disable Metrics/AbcSize
        min, max = data['releases'].values_at('minimum_version', 'maximum_version')
        raise ArgumentError, '`releases` must have a `minimum_version` version set' unless min

        site.data['kong_versions_gateway']
            .map { |r| r['release'] }
            .select { |v| Gem::Version.new(v) >= Gem::Version.new(min) }
            .select { |v| max.nil? || Gem::Version.new(v) <= Gem::Version.new(max) }
      end

      def replacements
        data.fetch('replacements', [])
      end
    end
  end
end

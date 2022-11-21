# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    class Versioned < Base
      def sources
        @sources ||= super.merge(data.fetch('sources', {}))
      end

      def releases
        @releases ||= ReleasesGenerator.call(
          releases: specified_or_delegated_releases,
          replacements:
        )
      end

      def extension?
        true
      end

      def ext_data
        {
          'releases' => releases,
          'strategy' => data['strategy'],
          'overrides' => data['overrides']
        }
      end

      private

      def data
        @data ||= SafeYAML.load(
          File.read(
            File.join(site.source, Generator::PLUGINS_FOLDER, dir, 'versions.yml')
          )
        )
      end

      def specified_or_delegated_releases
        (data['delegate_releases'] && delegated_releases) || data['releases']
      end

      def delegated_releases
        min, max = data['delegate_releases'].values_at('min', 'max')
        raise ArgumentError, '`delegate_releases` must have a `min` version set' unless min

        KongVersions
          .gateway
          .select { |v| Gem::Version.new(v) >= Gem::Version.new(min) }
          .select { |v| max.nil? || Gem::Version.new(v) <= Gem::Version.new(max) }
      end

      def replacements
        data.fetch('replacements', [])
      end
    end
  end
end

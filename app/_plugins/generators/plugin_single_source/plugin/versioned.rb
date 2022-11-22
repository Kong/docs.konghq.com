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
        (data['delegate_releases'] && KongVersions.gateway) || data['releases']
      end

      def replacements
        data.fetch('replacements', [])
      end
    end
  end
end

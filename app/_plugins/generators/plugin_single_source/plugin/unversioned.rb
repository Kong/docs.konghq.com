# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    class Unversioned < Base
      def releases
        @releases ||= if vendor == 'kong-inc'
                        ['1.0.0'] # If there's no version, assume it's 1.0.0
                      else
                        # If there's no version, assume it's latest
                        [Utils::Version.to_semver(latest_release)]
                      end
      end

      def extension?
        false
      end

      private

      def replacements
        []
      end

      def latest_release
        @site.data['kong_latest_gateway']['release']
      end
    end
  end
end

# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    class ReleasesGenerator
      def self.call(releases:, replacements:)
        new(releases:, replacements:).call
      end

      def initialize(releases:, replacements:)
        @releases     = releases
        @replacements = replacements
      end

      def call
        override_versions!

        @releases
          .flatten
          .sort_by { |v| Gem::Version.new(v) }
          .reverse
      end

      private

      def override_versions!
        @override_versions ||= @replacements.each do |k, v|
          @releases[@releases.index(k)] = v if @releases.index(k)
        end
      end
    end
  end
end

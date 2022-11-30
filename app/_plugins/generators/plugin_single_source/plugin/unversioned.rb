# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    class Unversioned < Base
      def releases
        @releases ||= ['1.0.0'] # If there's no version, assume it's 1.0.0
      end

      def extension?
        false
      end

      private

      def replacements
        []
      end
    end
  end
end

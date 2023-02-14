# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class Changelog < Base
      private

      def canonical_url
        "/#{base_url}changelog/"
      end

      def permalink
        if @release.latest?
          canonical_url.delete_prefix('/')
        else
          "#{base_url}#{@release.version}/changelog.html"
        end
      end

      def ssg_hub
        false
      end
    end
  end
end

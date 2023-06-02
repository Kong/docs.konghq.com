# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class Changelog < Base
      TITLE = 'Changelog'

      def canonical_url
        "#{base_url}changelog/"
      end

      def permalink
        if @release.latest?
          canonical_url
        else
          "#{base_url}#{@release.version}/changelog/"
        end
      end

      def page_title
        "#{@release.metadata['name']} #{TITLE}"
      end

      def dropdown_url
        @dropdown_url ||= "#{base_url}VERSION/changelog/"
      end

      def nav_title
        TITLE
      end

      def breadcrumb_title
        TITLE
      end

      def icon
        '/assets/images/icons/documentation/hub/icn-changelog.svg'
      end

      private

      def ssg_hub
        false
      end
    end
  end
end

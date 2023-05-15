# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class Overview < Base
      def canonical_url
        base_url
      end

      def permalink
        if @release.latest?
          canonical_url
        else
          "#{base_url}#{@release.version}/"
        end
      end

      def page_title
        @release.metadata['name'].to_s
      end

      def dropdown_url
        @dropdown_url ||= "#{base_url}VERSION/"
      end

      def nav_title
        'Overview'
      end

      def icon
        '/assets/images/icons/documentation/hub/icn-overview.svg'
      end

      def breadcrumb_title
        page_title
      end

      def breadcrumbs
        [
          { text: @release.metadata['categories'] },
          { text: breadcrumb_title, url: permalink }
        ]
      end

      private

      def ssg_hub
        @release.latest?
      end

      def page_attributes
        super.merge('layout' => 'extension')
      end
    end
  end
end

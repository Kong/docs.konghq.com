# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class Reference < Base
      TITLE = 'Configuration Reference'

      def canonical_url
        "#{base_url}reference/"
      end

      def permalink
        if @release.latest?
          canonical_url
        else
          "#{base_url}#{@release.version}/reference/"
        end
      end

      def page_title
        "#{@release.metadata['name']} #{TITLE}"
      end

      def dropdown_url
        @dropdown_url ||= "#{base_url}VERSION/reference/"
      end

      def source_file; end

      def content
        ''
      end

      def nav_title
        TITLE
      end

      def breadcrumb_title
        TITLE
      end

      def icon
        '/assets/images/icons/documentation/hub/icn-configuration.svg'
      end

      private

      def ssg_hub
        false
      end

      def layout
        'plugins/configuration-reference'
      end
    end
  end
end

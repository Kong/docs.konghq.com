# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class Configuration < Base
      TITLE = 'Configuration'

      def canonical_url
        "#{base_url}configuration/"
      end

      def permalink
        if @release.latest?
          canonical_url
        else
          "#{base_url}#{@release.version}/configuration/"
        end
      end

      def page_title
        "#{@release.metadata['name']} #{TITLE}"
      end

      def dropdown_url
        @dropdown_url ||= "#{base_url}VERSION/configuration/"
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
        'plugins/configuration'
      end
    end
  end
end

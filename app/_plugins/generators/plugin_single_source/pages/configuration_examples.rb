# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class ConfigurationExamples < Base
      TITLE = 'Examples'

      def canonical_url
        "#{base_url}configuration/examples/"
      end

      def permalink
        if @release.latest?
          canonical_url
        else
          "#{base_url}#{@release.version}/configuration/examples/"
        end
      end

      def page_title
        "#{@release.metadata['name']} Configuration #{TITLE}"
      end

      def dropdown_url
        @dropdown_url ||= "#{base_url}VERSION/configuration/examples"
      end

      def source_file; end

      def content
        ''
      end

      def nav_title
        TITLE
      end

      def breadcrumb_title
        "Configuration #{TITLE}"
      end

      def icon
        ''
      end

      private

      def ssg_hub
        false
      end

      def layout
        'plugins/configuration_examples'
      end
    end
  end
end

# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class ConfigurationExamples < Base
      TITLE = 'Basic config examples'

      def canonical_url
        "#{base_url}how-to/basic-example/"
      end

      def permalink
        if @release.latest?
          canonical_url
        else
          "#{base_url}#{@release.version}/how-to/basic-example/"
        end
      end

      def page_title
        "#{TITLE} for #{@release.metadata['name']}"
      end

      def dropdown_url
        @dropdown_url ||= "#{base_url}VERSION/how-to/basic-example/"
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

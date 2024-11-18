# frozen_string_literal: true

require_relative 'nestable'

module PluginSingleSource
  module Pages
    class Overview < Base
      include ::PluginSingleSource::Pages::Nestable

      def page_title
        @release.metadata['name'].to_s
      end

      def breadcrumb_title
        page_title
      end

      def breadcrumbs
        [
          { text: category_title, url: category_url },
          { text: breadcrumb_title, url: base_section_url },
          { text: I18n.t('hub.breadcrumbs.introduction', locale: translate_to) },
          { text: nav_title, url: permalink }
        ]
      end

      private

      def file_to_url_segment
        super.gsub('overview', '')
      end

      def ssg_hub
        @release.latest? && @file == 'overview/_index.md'
      end

      def page_attributes
        super.merge(
          'layout' => 'extension',
          'configuration_url' => configuration_url
        )
      end

      def base_section_url
        if @release.latest?
          base_url
        else
          "#{base_url}#{gateway_release}/"
        end
      end

      def configuration_url
        "#{base_section_url}configuration/"
      end
    end
  end
end

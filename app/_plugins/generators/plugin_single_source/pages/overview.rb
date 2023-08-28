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
          { text: breadcrumb_title },
          { text: 'Overview', url: base_section_url.concat('overview/') },
          { text: nav_title, url: permalink }
        ]
      end

      private

      def ssg_hub
        @release.latest? && @file == 'overview/_index.md'
      end

      def page_attributes
        super.merge('layout' => 'extension')
      end
    end
  end
end
